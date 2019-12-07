Shader "Custom/Holographic"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_DotProduct("Rim effect",Range(-1,1)) = 0.25
    }
    SubShader
    {
		Tags { "RenderType" = "Transparent" "IgnoreProject" = "True" "Queue" = "Transparent"}

        CGPROGRAM
        #pragma surface surf Standard alpha:fade noambient
        #pragma target 3.0

        sampler2D _MainTex;
		half _DotProduct;
		half4 _Color;

        struct Input
        {
            float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

			half border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
			half alpha = border * (1 - _DotProduct) + _DotProduct;
			o.Alpha = c.a * alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
