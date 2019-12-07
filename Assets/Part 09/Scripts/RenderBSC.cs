using UnityEngine;

[ExecuteInEditMode]
public class RenderBSC : MonoBehaviour
{
    #region Variables
    public Shader curShader;
    public float brightness = 1.0f, saturation = 1.0f, contrast = 1.0f;
    private Material screenMat;
    #endregion

    #region Properties
    Material ScreenMat
    {
        get
        {
            if (screenMat == null)
            {
                screenMat = new Material(curShader);
                screenMat.hideFlags = HideFlags.HideAndDontSave;
            }
            return screenMat;
        }
    }
    #endregion

    void Update()
    {
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
        brightness = Mathf.Clamp(brightness, 0.0f, 2.0f);
        saturation = Mathf.Clamp(saturation, 0.0f, 2.0f);
        contrast = Mathf.Clamp(contrast, 0.0f, 2.0f);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader != null)
        {
            ScreenMat.SetFloat("_Brightness", brightness);
            ScreenMat.SetFloat("_Saturation", saturation);
            ScreenMat.SetFloat("_Contrast", contrast);
            Graphics.Blit(source, destination, ScreenMat);
        }
        else Graphics.Blit(source, destination);
    }
}