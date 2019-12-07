Shader "Custom/Anisotropic"
{
    Properties
    {
		_MainTint("Diffuse Tint",Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
		_Specular("Specular Amount",Range(0,1)) = 0.5
		_SpecPower("Specular Power", Range(0,1)) = 0.5
		_AnisoDir("Anisotropic Direction",2D) = "white"{}
		_AnisoOffset("Anisotropic Offset",Range(-1,1)) = -0.2
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }

			CGPROGRAM
			#pragma surface surf Anisotropic
			#pragma target 3.0

		sampler2D _MainTex,_AnisoDir;
		half4 _SpecularColor, _MainTint;
		half _SpecPower, _Specular, _AnisoOffset;

		struct SurfaceAnisoOutput
		{
			fixed3 Albedo, Normal, Emission, AnisoDirection;
			half Specular;
			fixed Gloss, Alpha;
		};

        struct Input
        {
			float2 uv_MainTex, uv_AnisoDir;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceAnisoOutput o)
        {
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
			half3 anisoTex = UnpackNormal(tex2D(_AnisoDir, IN.uv_AnisoDir));

			o.AnisoDirection = anisoTex;
			o.Specular = _Specular;
			o.Gloss = _Specular;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
        }

		half4 LightingAnisotropic(SurfaceAnisoOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			half3 halfVector = normalize(normalize(lightDir) + normalize(viewDir));
			half NdotL = saturate(dot(s.Normal, lightDir));

			half HdotA = dot(normalize(s.Normal + s.AnisoDirection), halfVector);
			half aniso = saturate(sin(radians((HdotA + _AnisoOffset) * 180)));
			half spec = saturate(pow(aniso, s.Gloss * 128) * s.Specular);

			half4 color;
			color.rgb = (s.Albedo * _LightColor0.rgb * NdotL + _LightColor0.rgb * _SpecularColor.rgb * spec) * atten;
			color.a = s.Alpha;
			return color;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
