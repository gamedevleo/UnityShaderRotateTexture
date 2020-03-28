Shader "Custom/BRDF"
{
    Properties
    {
        _SpecularColor ("SpecColor", Color) = (1,1,1,1)
		_Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecPower("Specular Power",float) =1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf BRDFLighting

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _SpecularColor;
		fixed4 _Color;
		float _SpecPower;

		#define PI 3.1415926


		half4 LightingBRDFLighting(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			float3 H = normalize(viewDir +lightDir);
			float3 N = normalize(s.Normal);
			float d = (_SpecPower + 2)*pow(dot(N, H), _SpecPower) / 8.0;
			float f = _SpecularColor + (1 - _SpecularColor)*pow(1 - dot(H, N), 5);

			float k = 2.0 / (sqrt(PI*(_SpecPower + 2)));
			float v = 1 / ((dot(N, lightDir)*(1 - k) + k)*(dot(N, viewDir)*(1 - k) + k));
			
			//this is the Specular 
			float  all = d * f * v;

			//this is the diffuse;
			float diff = dot(lightDir, N);
			float tempResult = all + (1 - all)*diff;
			half4 finalColor = 0;
			finalColor.rgb = tempResult * s.Albedo * _LightColor0.rgb;
			finalColor.a = s.Alpha;
			return finalColor;
		}



        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex)*_Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
