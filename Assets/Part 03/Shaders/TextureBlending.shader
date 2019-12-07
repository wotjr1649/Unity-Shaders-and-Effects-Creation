Shader "Custom/TextureBlending"
{
	Properties
	{
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		_ColorA("Terrain Color A", Color) = (1,1,1,1)
		_ColorB("Terrain Color B", Color) = (1,1,1,1)
		_RTexture("Red Channel Texture",2D) = "red"{}
		_GTexture("Green Channel Texture",2D) = "green"{}
		_BTexture("Blue Channel Texture",2D) = "blue"{}
		_ATexture("Alpha Channel Texture",2D) = "black"{}
		_BlendTex("Blend Texture",2D) = "white"{}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.5

		half4 _MainTint,_ColorA,_ColorB;
		sampler2D _RTexture, _GTexture, _BTexture, _ATexture, _BlendTex;

		struct Input
		{
			float2 uv_RTexture, uv_GTexture, uv_BTexture, uv_ATexture, uv_BlendTex;
		};

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 blendData = tex2D(_BlendTex, IN.uv_BlendTex);
			fixed4 rTexData = tex2D(_RTexture, IN.uv_RTexture);
			fixed4 gTexData = tex2D(_GTexture, IN.uv_GTexture);
			fixed4 bTexData = tex2D(_BTexture, IN.uv_BTexture);
			fixed4 aTexData = tex2D(_ATexture, IN.uv_ATexture);

			fixed4 finalColor;
			finalColor = lerp(rTexData, gTexData, blendData.g);
			finalColor = lerp(finalColor, bTexData, blendData.b);
			finalColor = lerp(finalColor, aTexData, blendData.a);
			finalColor.a = 1;

			fixed4 terrainLayers = lerp(_ColorA, _ColorB, blendData.r);
			finalColor *= terrainLayers; finalColor = saturate(finalColor);
			o.Albedo = finalColor.rgb * _MainTint.rgb;
			o.Alpha = finalColor.a;
		}
		ENDCG
	}
		FallBack "Diffuse"
}
