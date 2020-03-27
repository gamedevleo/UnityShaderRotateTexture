Shader "Custom/Fresnel"
{
    Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Ratio("Ratio",Range(0.5,1.5)) = 1
		_FresnelBias("FresnelBias",float) = 1
		_FresnelPower("FresnelPower",float) = 1
		_FresnelScale("FresnelScale",float) = 1
	}
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert vertex:MyVertex
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		float _Ratio;
		float _FresnelBias;
		float _FresnelPower;
		float _FresnelScale;

        struct Input
        {
            float2 uv_MainTex;
			float3 worldRefl;
			float3 refract;
			float reflectFact;
        };

        fixed4 _Color;

		void MyVertex(inout appdata_full v, out Input data)
		{
			UNITY_INITIALIZE_OUTPUT(Input, data);

			float3 localNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
			float3 viewDir = WorldSpaceViewDir(v.vertex);

			data.refract = refract(viewDir, localNormal, _Ratio);
			data.reflectFact = _FresnelBias + _FresnelScale * pow(1 + dot(viewDir, localNormal), _FresnelPower);
		}



        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 cFlect = tex2D(_MainTex, IN.worldRefl)*_Color;
			fixed4 cFract = tex2D(_MainTex, IN.refract);

			o.Albedo = IN.reflectFact*cFlect.rgb + (1 - IN.reflectFact)*cFract.rgb;

            o.Alpha = cFlect.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
