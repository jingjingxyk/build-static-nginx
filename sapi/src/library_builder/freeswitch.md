# freeswitch 依赖库列表

## freeswitch port

```text/plain
Typical Ports
FireWall Ports	Network Protocol	Application Protocol	Description
1719	UDP	H.323 Gatekeeper RAS port
1720	TCP	H.323 Call Signaling
2855-2856	TCP	MSRP	Used for call with messaging
3478	UDP	STUN service	Used for NAT traversal
3479	UDP	STUN service	Used for NAT traversal
5002	TCP	MLP protocol server
5003	UDP	Neighborhood service
5060	UDP & TCP	SIP UAS	Used for SIP signaling (Standard SIP Port, for default Internal Profile)
5070	UDP & TCP	SIP UAS	Used for SIP signaling (For default "NAT" Profile)
5080	UDP & TCP	SIP UAS	Used for SIP signaling (For default "External" Profile)
8021	TCP	ESL	Used for mod_event_socket *
16384-32768	UDP	RTP/ RTCP multimedia streaming	Used for audio/video data in SIP, Verto, and other protocols
5066	TCP	Websocket	Used for WebRTC
7443	TCP	Websocket	Used for WebRTC
8081-8082	TCP	Websocket	Used for Verto
```
