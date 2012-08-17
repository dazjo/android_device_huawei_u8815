/*
 * Copyright (C) 2012 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.android.internal.telephony;

import static com.android.internal.telephony.RILConstants.*;

import android.content.Context;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.os.Parcel;
import android.telephony.SmsMessage;
import android.os.SystemProperties;
import android.text.TextUtils;
import android.util.Log;

import com.android.internal.telephony.RILConstants;
import com.android.internal.telephony.gsm.SmsBroadcastConfigInfo;
import com.android.internal.telephony.cdma.CdmaInformationRecords;

import java.util.ArrayList;

/**
 * Qualcomm RIL class for basebands that do not send the SIM status
 * piggybacked in RIL_UNSOL_RESPONSE_RADIO_STATE_CHANGED. Instead,
 * these radios will send radio state and we have to query for SIM
 * status separately.
 * Custom Qualcomm No SimReady RIL for Huawei
 *
 * {@hide}
 */

public class HWQcomRIL extends QualcommSharedRIL implements CommandsInterface {
    boolean RILJ_LOGV = true;
    boolean RILJ_LOGD = true;

    private final int RIL_INT_RADIO_OFF = 0;
    private final int RIL_INT_RADIO_UNAVAILABLE = 1;
    private final int RIL_INT_RADIO_ON = 2;
    private final int RIL_INT_RADIO_ON_NG = 10;
    private final int RIL_INT_RADIO_ON_HTC = 13;

    public HWQcomRIL(Context context, int networkMode, int cdmaSubscription) {
        super(context, networkMode, cdmaSubscription);
        mSetPreferredNetworkType = -1;
    }

    @Override
    protected DataCallState getDataCallState(Parcel p, int version) {
        DataCallState dataCall = new DataCallState();
        dataCall.version = version;
        if (version < 5)
        {
            dataCall.cid = p.readInt();
            dataCall.active = p.readInt();
            dataCall.type = p.readString();
            String addresses = p.readString();
            if (!TextUtils.isEmpty(addresses))
                dataCall.addresses = addresses.split(" ");
        } else {
            dataCall.status = p.readInt();
            dataCall.suggestedRetryTime = p.readInt();
            dataCall.cid = p.readInt();
            dataCall.active = p.readInt();
            dataCall.type = p.readString();
            dataCall.ifname = p.readString();
            if ((dataCall.status == DataConnection.FailCause.NONE.getErrorCode()) && (TextUtils.isEmpty(dataCall.ifname)) && (dataCall.active != 0))
                throw new RuntimeException("getDataCallState, no ifname");
            String addresses = p.readString();
            if (!TextUtils.isEmpty(addresses))
                dataCall.addresses = addresses.split(" ");
            String dnses = p.readString();
            if (!TextUtils.isEmpty(dnses))
                dataCall.dnses = dnses.split(" ");
            String gateways = p.readString();
            if (!TextUtils.isEmpty(gateways))
                dataCall.gateways = gateways.split(" ");
        }

        return dataCall;
    }

    @Override
    protected Object responseSetupDataCall(Parcel p) {
        int ver = p.readInt();
        int num = p.readInt();
        if (RILJ_LOGV) riljLog("responseSetupDataCall ver=" + ver + " num=" + num);

        DataCallState dataCall;

        if (ver < 5) {
            dataCall = new DataCallState();
            dataCall.version = ver;
            dataCall.cid = Integer.parseInt(p.readString());
            dataCall.ifname = p.readString();
            if (TextUtils.isEmpty(dataCall.ifname)) {
                throw new RuntimeException(
                    "RIL_REQUEST_SETUP_DATA_CALL response, no ifname");
            }
            String addresses = p.readString();
            if (!TextUtils.isEmpty(addresses)) {
                dataCall.addresses = addresses.split(" ");
            }
            if (num >= 4) {
                String dnses = p.readString();
                if (RILJ_LOGD) riljLog("responseSetupDataCall got dnses=" + dnses);
                if (!TextUtils.isEmpty(dnses)) {
                    dataCall.dnses = dnses.split(" ");
                }
            }
            if (num >= 5) {
                String gateways = p.readString();
                if (RILJ_LOGD) riljLog("responseSetupDataCall got gateways=" + gateways);
                if (!TextUtils.isEmpty(gateways)) {
                    dataCall.gateways = gateways.split(" ");
                }
            }
        } else {
            if (num != 1) {
                throw new RuntimeException(
                    "RIL_REQUEST_SETUP_DATA_CALL response expecting 1 RIL_Data_Call_response_v5"
                    + " got " + num);
            }
            dataCall = getDataCallState(p, ver);
        }

        return dataCall;
    }

    @Override
    protected void
    processUnsolicited (Parcel p) {
        Object ret;
        int dataPosition = p.dataPosition(); // save off position within the Parcel
        int response = p.readInt();

        switch(response) {
            case RIL_UNSOL_RESPONSE_RADIO_STATE_CHANGED: ret =  responseVoid(p); break;
            case RIL_UNSOL_RIL_CONNECTED: ret = responseInts(p); break;
            case 1035: ret = responseVoid(p); break; // RIL_UNSOL_VOICE_RADIO_TECH_CHANGED
            case 1036: ret = responseVoid(p); break; // RIL_UNSOL_RESPONSE_IMS_NETWORK_STATE_CHANGED
            case 1037: ret = responseVoid(p); break; // RIL_UNSOL_EXIT_EMERGENCY_CALLBACK_MODE
            case 1038: ret = responseVoid(p); break; // RIL_UNSOL_DATA_NETWORK_STATE_CHANGED

            default:
                // Rewind the Parcel
                p.setDataPosition(dataPosition);

                // Forward responses that we are not overriding to the super class
                super.processUnsolicited(p);
                return;
        }

        switch(response) {
            case RIL_UNSOL_RESPONSE_RADIO_STATE_CHANGED:
                int state = p.readInt();
                setRadioStateFromRILInt(state);
                break;
            case 1035:
            case 1036:
                break;
            case 1037: // RIL_UNSOL_EXIT_EMERGENCY_CALLBACK_MODE
                if (RILJ_LOGD) unsljLogRet(response, ret);

                if (mExitEmergencyCallbackModeRegistrants != null) {
                    mExitEmergencyCallbackModeRegistrants.notifyRegistrants(
                                        new AsyncResult (null, null, null));
                }
                break;
            case 1038:
                break;
        }
    }

    private void setRadioStateFromRILInt (int stateCode) {
        CommandsInterface.RadioState radioState;
        HandlerThread handlerThread;
        Looper looper;
        IccHandler iccHandler;

        switch (stateCode) {
            case RIL_INT_RADIO_OFF:
                radioState = CommandsInterface.RadioState.RADIO_OFF;
                if (mIccHandler != null) {
                    mIccThread = null;
                    mIccHandler = null;
                }
                break;
            case RIL_INT_RADIO_UNAVAILABLE:
                radioState = CommandsInterface.RadioState.RADIO_UNAVAILABLE;
                break;
            case RIL_INT_RADIO_ON:
            case RIL_INT_RADIO_ON_NG:
            case RIL_INT_RADIO_ON_HTC:
                if (mIccHandler == null) {
                    handlerThread = new HandlerThread("IccHandler");
                    mIccThread = handlerThread;

                    mIccThread.start();

                    looper = mIccThread.getLooper();
                    mIccHandler = new IccHandler(this,looper);
                    mIccHandler.run();
                }
                radioState = CommandsInterface.RadioState.RADIO_ON;
                break;
            default:
                throw new RuntimeException("Unrecognized RIL_RadioState: " + stateCode);
        }

        setRadioState (radioState);
    }
}
