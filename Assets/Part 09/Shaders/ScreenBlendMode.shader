Shader "Custom/ScreenBlendMode"
{
	Properties
	{
		 _MainTex("Base (RGB)",2D) = "white"{}
		_BlendTex("Blend Texture",2D) = "white"{}
		_Opacity("Blend Opacity",Range(0,1)) = 1
		//[KeywordEnum(blendedMultiply,blendedAdd,blendedScreen)]
		_BlendMode("BlendMode",int) = 0
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
						int _BlendMode;

						fixed4 frag(v2f_img i) :COLOR
						{
							//렌더 텍스쳐로부터 색상을,v2f_img로부터 uv를 얻는다
							fixed4 renderTex = tex2D(_MainTex,i.uv);
							fixed4 blendTex = tex2D(_BlendTex, i.uv);
							fixed4 blended;
							//곱하기 혼합 모드를 수행한다
							if (_BlendMode == 0)blended = renderTex * blendTex;
							//더하기 혼합 모드를 수행한다
							else if (_BlendMode == 1)blended = renderTex + blendTex;
							//화면 혼합 모드를 수행한다
							else blended = (1.0 - ((1.0 - renderTex) * (1.0 - blendTex)));
							//lerp로 혼합 모드의 양을 조절한다
							renderTex = lerp(renderTex, blended, _Opacity);
							return renderTex;
						}
							ENDCG
					}
		}
			FallBack off
}