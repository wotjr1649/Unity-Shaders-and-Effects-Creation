Shader "Custom/NormalShader"
{
	Properties
	{
		_MainTint("Diffuse Tint",Color) = (0,1,0,1)
		_NormalTex("Normal Map",2D) = "bump"{}
		_NormalMapIntensity("Normal intensity",Range(0,3)) = 1
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		sampler2D _NormalTex;
		half4 _MainTint;
		half _NormalMapIntensity;

        struct Input
        {
            float2 uv_NormalTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			half3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			normalMap.x *= _NormalMapIntensity;
			normalMap.y *= _NormalMapIntensity;
			o.Normal = normalize(normalMap);
			o.Albedo = _MainTint;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
