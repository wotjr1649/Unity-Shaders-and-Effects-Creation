using UnityEngine;

[ExecuteInEditMode]
public class TestRenderImage : MonoBehaviour
{
    #region Variables
    public Shader curShader;
    public float grayscaleAmount = 1.0f;
    private Material screenMat;
    #endregion

    #region Properties
    Material ScreenMat
    {
        get
        {
            if(screenMat == null)
            {
                screenMat = new Material(curShader);
                screenMat.hideFlags = HideFlags.HideAndDontSave;
            }
            return screenMat;
        }
    }
    #endregion

    void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if (!curShader && !curShader.isSupported)
        {
            enabled = false;
        }
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (curShader != null)
        {
            ScreenMat.SetFloat("_Luminosity", grayscaleAmount);
            Graphics.Blit(sourceTexture, destTexture, ScreenMat);
        }
        else Graphics.Blit(sourceTexture, destTexture);
    }

    void Update()
    {
        grayscaleAmount = Mathf.Clamp(grayscaleAmount, 0.0f, 1.0f);
    }
    void OnDisable()
    {
        if (screenMat)
            DestroyImmediate(screenMat);
    }
}
