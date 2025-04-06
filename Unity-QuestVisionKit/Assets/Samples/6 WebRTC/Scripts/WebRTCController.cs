using PassthroughCameraSamples;
#if WEBRTC_ENABLED
using SimpleWebRTC;
#endif
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

namespace QuestCameraKit.WebRTC {
    public class WebRTCController : MonoBehaviour {
        [SerializeField] private WebCamTextureManager passthroughCameraManager;
        [SerializeField] private RawImage canvasRawImage;
        [SerializeField] private GameObject connectionGameObject;

#if WEBRTC_ENABLED
        private WebCamTexture _webcamTexture;
        private WebRTCConnection _webRTCConnection;

        private IEnumerator Start() {
            yield return new WaitUntil(() => passthroughCameraManager.WebCamTexture != null && passthroughCameraManager.WebCamTexture.isPlaying);

            _webRTCConnection = connectionGameObject.GetComponent<WebRTCConnection>();
            _webcamTexture = passthroughCameraManager.WebCamTexture;
            canvasRawImage.texture = _webcamTexture;
        }

        private void Update() {
            if (OVRInput.Get(OVRInput.Button.Start)) {
                _webRTCConnection.StartVideoTransmission();
            }
        }
#endif
    }
}