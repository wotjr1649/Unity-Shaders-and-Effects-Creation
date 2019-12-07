Shader "Custom/MobileShader"
{
    Properties
    {
		_Diffuse("Base (RGB)",2D) = "white"{}
		_SpecIntensity("Specular Width",Range(0.01,1)) = 0.5
		_NormalMap("Normal Map",2D) = "bump"{}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf MobileBlinnPhong exclude_path:prepass nolightmap noforwardadd halfasview
		#pragma target 3.0

		sampler2D _Diffuse,_NormalMap;
		half _SpecIntensity;

        struct Input
        {
            float2 uv_Diffuse;
        };

		inline fixed4 LightingMobileBlinnPhong(SurfaceOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
		{
			fixed diff = saturate(dot(s.Normal, lightDir));
			fixed NdotH = saturate(dot(s.Normal, halfDir));
			fixed spec = pow(NdotH, s.Specular * 128) * s.Gloss;
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten * 2;
			c.a = 0;
			return c;
		}

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 c = tex2D(_Diffuse, IN.uv_Diffuse);
            o.Albedo = c.rgb;
			o.Gloss = c.a;
            o.Alpha = 0;
			o.Specular = _SpecIntensity;
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_Diffuse));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
