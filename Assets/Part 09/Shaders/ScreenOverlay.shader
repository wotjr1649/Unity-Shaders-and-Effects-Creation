Shader "Custom/ScreenOverlay"
{
	Properties
	{
		 _MainTex("Base (RGB)",2D) = "white"{}
		_BlendTex("Blend Texture",2D) = "white"{}
		_Opacity("Blend Opacity",Range(0,1)) = 1
	}
		SubShader
		{
				Pass
					{
						CGPROGRAM
						#pragma vertex vert_img
						#pragma fragment frag
						#pragma fragmentoption ARB_precision_hint_fastest
						#include "UnityCG.cginc"

						uniform sampler2D _MainTex,_BlendTex;
						fixed _Opacity;

						fixed OverlayBlendMode(fixed basePixel, fixed blendPixel)
						{
							return	basePixel < 0.5 ? (2.0 * basePixel * blendPixel) : (1.0 - 2.0 * (1.0 - basePixel) * (1.0 - blendPixel));
						}

						fixed4 frag(v2f_img i) :COLOR
						{
							//렌더 텍스쳐로부터 색상을,v2f_img로부터 uv를 얻는다
							fixed4 renderTex = tex2D(_MainTex,i.uv);
							fixed4 blendTex = tex2D(_BlendTex, i.uv);
							fixed4 blendedImage = renderTex;
							blendedImage.r = OverlayBlendMode(renderTex.r, blendTex.r);
							blendedImage.g = OverlayBlendMode(renderTex.g, blendTex.g);
							blendedImage.b = OverlayBlendMode(renderTex.b, blendTex.b);
							//lerp로 혼합 모드의 양을 조절한다
							renderTex = lerp(renderTex, blendedImage, _Opacity);
							return renderTex;
						}
							ENDCG
					}
		}
			FallBack off
}