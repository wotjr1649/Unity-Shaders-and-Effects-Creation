Shader "Custom/SnowShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("NormalMap",2D) = "bump"{}
		_Snow("Level of snow",Range(-1,1)) = 1
		_SnowColor("Color of Snow",Color) = (1,1,1,1)
		_SnowDirection("Direction of snow",Vector) = (0,1,0)
		_SnowDepth("Depth of Snow",Range(0,1)) = 0
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }

			CGPROGRAM
			#pragma surface surf Standard vertex:vert
			#pragma target 3.0

			sampler2D _MainTex,_BumpMap;
			half4 _SnowColor, _Color, _SnowDirection;
			half _Snow, _SnowDepth;

        struct Input
        {
			float2 uv_MainTex, uv_BumpMap;
			float3 worldNormal;
			INTERNAL_DATA
        };

		void vert(inout appdata_full v)
		{
			half4 sn = mul(UNITY_MATRIX_IT_MV, _SnowDirection);
			if (dot(v.normal, sn.xyz) >= _Snow)
				v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;
		}

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Albedo = dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) >= _Snow ? _SnowColor.rgb : c.rgb * _Color;
			o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
