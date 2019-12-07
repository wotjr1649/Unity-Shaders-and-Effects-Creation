Shader "Custom/NormalExtrusion"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Amount("Extrusion Amount",Range(-0.0001,0.0001)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard vertex:vert
        #pragma target 3.0

        sampler2D _MainTex;
		half4 _Color;
		float _Amount;

        struct Input
        {
            float2 uv_MainTex;
        };

		void vert(inout appdata_full v)
		{
			v.vertex.xyz += v.normal * _Amount;
		}

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb * _Color;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
