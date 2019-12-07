using UnityEngine;
using System;

public enum Mode
{
    blendedMultiply = 0, blendedAdd = 1, blendedScreen = 2
}

[ExecuteInEditMode]
public class RenderBlendMode : MonoBehaviour
{
    #region Variables
    public Shader curShader;
    public Texture2D blendTexture;
    public float blendOpacity = 1.0f;
    public Mode BlendMode;
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
        blendOpacity = Mathf.Clamp(blendOpacity, 0.0f, 1.0f);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader != null)
        {
            ScreenMat.SetTexture("_BlendTex", blendTexture);
            ScreenMat.SetFloat("_Opacity", blendOpacity);
            ScreenMat.SetInt("_BlendMode", Convert.ToInt16(BlendMode));
            Graphics.Blit(source, destination, ScreenMat);
        }
        else Graphics.Blit(source, destination);
    }
}
  