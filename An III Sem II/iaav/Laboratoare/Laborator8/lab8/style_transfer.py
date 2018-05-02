import matplotlib.pyplot as plt
import tensorflow as tf
import numpy as np
import PIL.Image
from IPython.display import Image, display

import vgg16

# vgg16.data_dir = 'vgg16/'
vgg16.maybe_download()

def load_image(filename, max_size=None):
    image = PIL.Image.open(filename)

    if max_size is not None:
        # Calculează factorul de scalare necesat pentru
        # a asigura înălțimea și lățimea maxime, păstrând,
        # în același timp, proporțiile dintre acestea.
        factor = max_size / np.max(image.size)

        # Redimensionează imaginea
        size = np.array(image.size) * factor
        size = size.astype(int)

        image = image.resize(size, PIL.Image.LANCZOS)

    return np.float32(image)

def save_image(image, filename):
    # Asigură că valorile pixelilor sunt în [0, 255]
    image = np.clip(image, 0.0, 255.0)

    # Convertește în bytes
    image = image.astype(np.uint8)

    # Scrie imaginea
    with open(filename, 'wb') as file:
        PIL.Image.fromarray(image).save(file, 'jpeg')

def plot_image_big(image):
    # Asigură că valorile pixelilor sunt în [0, 255]
    image = np.clip(image, 0.0, 255.0)

    # Convertește în bytes
    image = image.astype(np.uint8)

    # Afișează imaginea
    display(PIL.Image.fromarray(image))

def plot_images(content_image, style_image, mixed_image):
    fig, axes = plt.subplots(1, 3, figsize=(10, 10))

    fig.subplots_adjust(hspace=0.1, wspace=0.1)

    smooth = True
    if smooth:
        interpolation = 'sinc'
    else:
        interpolation = 'nearest'

    # Afișează imaginea-conținut
    ax = axes.flat[0]
    ax.imshow(content_image / 255.0, interpolation=interpolation)
    ax.set_xlabel("Content")

    # Afișează imaginea-mix
    ax = axes.flat[1]
    ax.imshow(mixed_image / 255.0, interpolation=interpolation)
    ax.set_xlabel("Mixed")

    # Afișează imaginea-stil
    ax = axes.flat[2]
    ax.imshow(style_image / 255.0, interpolation=interpolation)
    ax.set_xlabel("Style")

    for ax in axes.flat:
        ax.set_xticks([])
        ax.set_yticks([])

    plt.show()

# Calculează MSE între 2 tensori

def mean_squared_error(a, b):
    return tf.reduce_mean(tf.square(a - b))

def create_content_loss(session, model, content_image, layer_ids):
    """
    Creează funcția de loss a imaginii-conținut.

    Parametri:
    session: sesiune Tensorflow pentru rularea grafului modelului.
    model: modelul (instanță a clasei VGG)
    content_image: array numpy reprezentând imaginea-conținut
    layer_ids: Listă de id-uri de layere
    """

    feed_dict = model.create_feed_dict(image=content_image)

    # Obține referințele către tensorii layerelor.
    layers = model.get_layer_tensors(layer_ids)

    # Calculează rezultatele tensorilor respectivi
    values = session.run(layers, feed_dict=feed_dict)

    with model.graph.as_default():
        # Listă vidă pentru funcțiile de loss
        layer_losses = []

        # Pentru fiecare layer
        for value, layer in zip(values, layers):
            value_const = tf.constant(value)

            # Calculează MSE
            loss = mean_squared_error(layer, value_const)

            # Adaugă la lista de loss-uri
            layer_losses.append(loss)

        # Calculează media loss-urilor
        total_loss = tf.reduce_mean(layer_losses)

    return total_loss

def gram_matrix(tensor):
    shape = tensor.get_shape()

    # Obține numărul de canale.
    num_channels = int(shape[3])

    matrix = tf.reshape(tensor, shape=[-1, num_channels])

    # Calculează matricea Gram ca produs scalar între
    # toate combinațiile de 2 canale din tensor
    gram = tf.matmul(tf.transpose(matrix), matrix)

    return gram 

def create_style_loss(session, model, style_image, layer_ids):
    """
    Funcția loss pentru imaginea-stil.

    Parametri:
    session: sesiune Tensorflow pentru rularea grafului modelului.
    model: modelul (instanță a clasei VGG)
    style_image: array numpy reprezentând imaginea-stil
    layer_ids: Listă de id-uri de layere
    """

    feed_dict = model.create_feed_dict(image=style_image)

    # Obține referințele către tensorii layerelor.
    layers = model.get_layer_tensors(layer_ids)

    with model.graph.as_default():
        # Operațiile Tensorflow pentru calculul matricelor Gram
        gram_layers = [gram_matrix(layer) for layer in layers]

        # Calculează valorile matricelor Gram
        values = session.run(gram_layers, feed_dict=feed_dict)

        # Listă vidă pentru loss-uri
        layer_losses = []

        # Pentru fiecare matrice Gram
        for value, gram_layer in zip(values, gram_layers):
            value_const = tf.constant(value)

            # Calculează MSE
            loss = mean_squared_error(gram_layer, value_const)

            # Adaugă la lista de loss-uri
            layer_losses.append(loss)

        # Calculează media
        total_loss = tf.reduce_mean(layer_losses)

    return total_loss

def create_denoise_loss(model):
    loss = tf.reduce_sum(tf.abs(model.input[:,1:,:,:] - model.input[:,:-1,:,:])) + \
           tf.reduce_sum(tf.abs(model.input[:,:,1:,:] - model.input[:,:,:-1,:]))

    return loss

def style_transfer(content_image, style_image,
                   content_layer_ids, style_layer_ids,
                   weight_content=1.5, weight_style=10.0,
                   weight_denoise=0.3,
                   num_iterations=120, step_size=10.0):
    """
    Aplică SGD pentru a minimica loss-urile layerelor de conținut
    și de stil; asta ar trebui să rezulte într-o imagine care
    păstrează contururile din imaginea-conținut, respectiv culoarea
    și textura imaginii-stil.
    
    Parametri:
    content_image: Imaginea-conținut
    style_image: Imaginea-stil
    content_layer_ids: Lista id-urilor layere-lor de conținut
    style_layer_ids: Lista id-urilor layere-lor de stil
    weight_content: Ponderea loss-ului de conținut
    weight_style: Ponderea loss-ului de stil
    weight_denoise: Ponderea loss-ului de denoise
    num_iterations: Numărul de iterații
    step_size: Dimensiunea unui pas al gradientului în fiecare iterație
    """

    # Creează o instanță a modelului VGG16
    model = vgg16.VGG16()

    # Creează o sesiune Tensorflow
    session = tf.InteractiveSession(graph=model.graph)

    # Printează denumirea layar-elor-conținut
    print("Content layers:")
    print(model.get_layer_names(content_layer_ids))
    print()

    # Printează denumirea layer-elor-stil
    print("Style layers:")
    print(model.get_layer_names(style_layer_ids))
    print()

    # Creează loss-ul de conținut
    loss_content = create_content_loss(session=session,
                                       model=model,
                                       content_image=content_image,
                                       layer_ids=content_layer_ids)

    # Creează loss-ul de stil
    loss_style = create_style_loss(session=session,
                                   model=model,
                                   style_image=style_image,
                                   layer_ids=style_layer_ids)    

    # Creează loss-ul de denoise
    loss_denoise = create_denoise_loss(model)

    # Variabile pentru ponderile loss-urilor
    adj_content = tf.Variable(1e-10, name='adj_content')
    adj_style = tf.Variable(1e-10, name='adj_style')
    adj_denoise = tf.Variable(1e-10, name='adj_denoise')

    session.run([adj_content.initializer,
                 adj_style.initializer,
                 adj_denoise.initializer])

    # Operații Tensorflow pentru actualizarea ponderilor
    update_adj_content = adj_content.assign(1.0 / (loss_content + 1e-10))
    update_adj_style = adj_style.assign(1.0 / (loss_style + 1e-10))
    update_adj_denoise = adj_denoise.assign(1.0 / (loss_denoise + 1e-10))

    # Media ponderată a loss-urilor (pe aceasta o vom minimiza)
    loss_combined = weight_content * adj_content * loss_content + \
                    weight_style * adj_style * loss_style + \
                    weight_denoise * adj_denoise * loss_denoise

    gradient = tf.gradients(loss_combined, model.input)

    # Lista tensorilor pe care-i vom actualiza
    run_list = [gradient, update_adj_content, update_adj_style, \
                update_adj_denoise]

    # Inițializează random imaginea-mix
    mixed_image = np.random.rand(*content_image.shape) + 128

    for i in range(num_iterations):
        feed_dict = model.create_feed_dict(image=mixed_image)

        # Calculează valoarea gradientului
        grad, adj_content_val, adj_style_val, adj_denoise_val \
        = session.run(run_list, feed_dict=feed_dict)

        # Reduce dimensionalitatea gradientului
        grad = np.squeeze(grad)

        step_size_scaled = step_size / (np.std(grad) + 1e-8)

        # Actualizează imaginea-mix
        mixed_image -= grad * step_size_scaled

        # Asigură că valorile pixelilor sunt în [0.0, 255.0]
        mixed_image = np.clip(mixed_image, 0.0, 255.0)

        print(". ", end="")

        # Afișează status la fiecare 10 iterații
        if (i % 10 == 0) or (i == num_iterations - 1):
            print()
            print("Iteration:", i)

            # Afișează ponderi
            msg = "Weight Adj. for Content: {0:.2e}, Style: {1:.2e}, Denoise: {2:.2e}"
            print(msg.format(adj_content_val, adj_style_val, adj_denoise_val))

            # Afișează imaginile
            plot_images(content_image=content_image,
                        style_image=style_image,
                        mixed_image=mixed_image)

    print()
    print("Final image:")
    plot_image_big(mixed_image)

    session.close()

    return mixed_image

# content_filename = 'images/willy_wonka_old.jpg'
content_filename = 'willy_wonka_new.jpg'
content_image = load_image(content_filename, max_size=None)

# style_filename = 'images/style7.jpg'
style_filename = 'style3.jpg'
style_image = load_image(style_filename, max_size=300)

content_layer_ids = [4]

# Modelul VGG-16 are 13 layere convoluționale.
# Aceasta selectează toate layerele.
style_layer_ids = list(range(13))

# Puteți selecta și un subset de layere
# style_layer_ids = [1, 2, 3, 4]

img = style_transfer(content_image=content_image,
                     style_image=style_image,
                     content_layer_ids=content_layer_ids,
                     style_layer_ids=style_layer_ids,
                     weight_content=1.5,
                     weight_style=10.0,
                     weight_denoise=0.3,
                     num_iterations=60,
                     step_size=10.0)
