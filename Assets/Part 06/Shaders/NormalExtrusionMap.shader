Shader "Custom/Normal Extrusion Map"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ExtrusionTex("Extrusion map",2D) = "white"{}
		_Amount("Extrusion Amount",Range(-0.0001,0.0001)) = 0
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }

			CGPROGRAM
			#pragma surface surf Standard vertex:vert
			#pragma target 3.0

			sampler2D _MainTex,_ExtrusionTex;
			float _Amount;

        struct Input
        {
            float2 uv_MainTex;
        };

		void vert(inout appdata_full v)
		{
			half4 tex = tex2Dlod(_ExtrusionTex, half4(v.texcoord.xy, 0, 0));
			half extrusion = tex.r * 2 - 1;
			v.vertex.xyz += v.normal * _Amount * extrusion;
		}

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			fixed4 tex = tex2D(_ExtrusionTex, IN.uv_MainTex);
			half extrusion = abs(tex.r * 2 - 1);

			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			o.Albedo = lerp(o.Albedo.rgb, float3(0, 0, 0), extrusion * _Amount / 0.0001 * 1.1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
