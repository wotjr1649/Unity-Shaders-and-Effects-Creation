Shader "Custom/VertexAnimation"
{
	Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_tintAmount("Tint Amount",Range(0,1)) = 0.5
		_ColorA("Color A",Color) = (1,1,1,1)
		_ColorB("Color B", Color) = (1,1,1,1)
		_Speed("Wave Speed",Range(0.1,80)) = 5
		_Frequency("Wave Frequency",Range(0,5)) = 2
		_Amplitude("Wave Amplitude",Range(-1,1)) = 1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard vertex:vert
        #pragma target 3.0

        sampler2D _MainTex;
		half4 _ColorA, _ColorB;
		half _tintAmount, _Speed, _Frequency, _Amplitude, _OffsetVal;

        struct Input
        {
            float2 uv_MainTex;
			half3 vertColor;
        };

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			half time = _Time * _Speed;
			half waveValueA = sin(time + v.vertex.x * _Frequency) * _Amplitude;

			v.vertex.xyz = half3(v.vertex.x, v.vertex.y + waveValueA, v.vertex.z);
			v.normal = normalize(half3(v.normal.x + waveValueA, v.normal.y, v.normal.z));
			o.vertColor = half3(waveValueA, waveValueA, waveValueA);
		}

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			half3 tintColor = lerp(_ColorA, _ColorB, IN.vertColor.rgb);
			o.Albedo = c.rgb * tintColor * _tintAmount;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
