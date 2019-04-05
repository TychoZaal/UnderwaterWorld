using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BindPostProcessing : MonoBehaviour
{
    public Material postProcessingMaterial;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, postProcessingMaterial);
    }
}
