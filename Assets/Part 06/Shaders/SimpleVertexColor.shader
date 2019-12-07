Shader "Custom/SimpleVertexColor"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0


        struct Input
        {
			float4 vertColor;
        };

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.vertColor = v.color;
		}

        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Emission = IN.vertColor.rgb * _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
