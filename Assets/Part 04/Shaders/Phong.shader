Shader "Custom/Phong"
{
	Properties
	{
		_MainTint("Diffuse Tint",Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
		_SpecPower("Specular Power", Range(0, 30)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Phong
        #pragma target 3.0

        sampler2D _MainTex;
		half4 _SpecularColor, _MainTint;
		half _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
        };


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

		half4 LightingPhong(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			//반사
			half NdotL = dot(s.Normal, lightDir);
			half3 reflectionVector = normalize(2.0 * s.Normal * NdotL - lightDir);

			//스페큘러
			half spec = pow(saturate(dot(reflectionVector, viewDir)), _SpecPower);
			half3 finalSpec = _SpecularColor.rgb * spec;

			half4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * saturate(NdotL) * atten + _LightColor0.rgb * finalSpec;
			color.a = s.Alpha;
			return color;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
