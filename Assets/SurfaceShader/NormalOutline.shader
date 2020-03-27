Shader "Custom/NormalOutline"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalTex("NormalMap", 2D) = "white"{}
		_EmissionPower("EmissionPower",Range(0.5,2)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _NormalTex;
        struct Input
        {
            float2 uv_MainTex;
			float2 uv_NormalTex;
			float3 viewDir;
        };

        fixed4 _Color;
		float _EmissionPower;


        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			float3 tempNormal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));

			o.Normal = tempNormal;
			float outline = 1-clamp(dot(IN.viewDir, tempNormal), 0, 1);
			
            o.Emission = _Color*pow(outline,_EmissionPower);
			o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
