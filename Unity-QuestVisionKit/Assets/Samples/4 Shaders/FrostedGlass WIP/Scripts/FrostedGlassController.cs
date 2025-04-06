using System.Collections;
using UnityEngine;
using PassthroughCameraSamples;

namespace QuestCameraKit.FrostedGlass
{
    public class FrostedGlassController : MonoBehaviour
    {
        [SerializeField] private WebCamTextureManager passthroughCameraManager;
        [SerializeField] private Material baseMapMaterial;

        private WebCamTexture _webcamTexture;
        private static readonly int BaseMapId = Shader.PropertyToID("_BaseMap");

        private IEnumerator Start()
        {
            yield return new WaitUntil(() => passthroughCameraManager.WebCamTexture != null && passthroughCameraManager.WebCamTexture.isPlaying);

            _webcamTexture = passthroughCameraManager.WebCamTexture;
            baseMapMaterial.SetTexture(BaseMapId, _webcamTexture);
        }
    }
}