/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Cip
 */

import java.io.Serializable;

public class Message implements Serializable
{
    public enum MsgType { MSG_INVALID, MSG_DISCONNECT, MSG_ADD, MSG_MUL, MSG_POW };
    public MsgType mType;    
    
    Message() { mType = MsgType.MSG_INVALID; mN = 0; }
    
    // TODO: as you can see ideally we should have a base class for message then multiple derived class depending on message type
    public int mN;
    public int[] mNumbers;
    public int mA, mB;
}
