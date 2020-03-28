Shader "Custom/CustomLighting"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecPower("Specular", Range(0,1) ) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Simple

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
		float _SpecPower;

        void surf (Input IN, inout SurfaceOutput o)
        {
  
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
		half4 LightingSimple(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			
			float NDotL = dot(lightDir, s.Normal);
			half4 result = 0;
			half3 H = viewDir + lightDir;
			float HDotN = dot(H, s.Normal);
			//diffuse + specular
			result.rgb = s.Albedo*_LightColor0 * NDotL* atten + HDotN*_LightColor0*s.Albedo*_SpecPower;
			result.a = s.Alpha;
			return result;
		}


        ENDCG
    }
    FallBack "Diffuse"
}
