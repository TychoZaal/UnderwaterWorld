Shader "Bubble"
{
    Properties
	{
        _Color("_Color", Color) = (0.0,1.0,0.0,1.0)
        _Inside("_Inside", Range(0.0,2.0) ) = 0.0
        _Density("_Density", Range(0.0,2.0) ) = 1.2
        _Texture("_Texture", 2D) = "white" {}
        _Speed("_Speed", Range(0.5,5.0) ) = 0.5
        _Tile("_Tile", Range(1.0,10.0) ) = 5.0
        _Strength("_Strength", Range(0.0,5.0) ) = 1.5
        _Cube ("Reflection Cubemap", Cube) = "black" {TexGen CubeReflect }
    }
    SubShader
    {
        Tags
		{
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"   
        }
        Cull Back
		ZWrite On
        ZTest LEqual

        CGPROGRAM
		#pragma surface surf BlinnPhong alpha
        #pragma target 3.0

		float4 _Color;
        sampler2D _CameraDepthTexture;
		float _Inside;
		float _Density;
        sampler2D _Texture;
        float _Speed;
        float _Tile;
        float _Strength;
        samplerCUBE _Cube;

        inline half4 LightingBlinnPhongEditor_PrePass (SurfaceOutput s, half4 light)
        {
            half3 spec = light.a * s.Gloss;
            half4 c = half4(0,0, 0,0);
            c.rgb = (s.Albedo * light.rgb + light.rgb * spec);
            return c;
        }
        inline half4 LightingBlinnPhongEditor (SurfaceOutput s, half3 lightDir, half3 viewDir)
		{
            viewDir = normalize(viewDir);
            half3 h = normalize (lightDir + viewDir);
            half diff = max (0, dot (s.Normal, lightDir));
            float nh = max (0, dot (s.Normal, h));
            half4 res;
            res.rgb = _LightColor0.rgb * (diff * 2.0);
            return LightingBlinnPhongEditor_PrePass( s, res );
        }

        struct Input
		{
            float4 screenPos;
            float3 viewDir;
            float2 uv_Texture;
            float3 worldRefl;
			INTERNAL_DATA
        };

        void vert (inout appdata_full v, out Input o)
        {
		    o.screenPos = v.vertex;
            o.viewDir = v.normal;
            o.uv_Texture = v.texcoord;
            o.worldRefl = float3(0.3, 0.3, 0.3);
        }

        void surf (Input IN, inout SurfaceOutput o)
		{
            o.Albedo = float3(0.0, 0.0, 0.0);
            o.Normal = float3(0.0, 0.0, 1.0);
			float4 Fresnel0_1_NoInput = fixed4(0,0, 1.0, 1.0);
			float f = 1.0 - dot(normalize(IN.viewDir), normalize(Fresnel0_1_NoInput.xyz));
            float4 Fresnel0=float4(f, f, f, f);
            float4 StepReflection = step(Fresnel0,float4( 1.0, 1.0, 1.0, 1.0 ));
            float4 ClampedStepReflection = clamp(StepReflection, _Inside.xxxx, float4( 1.0, 1.0, 1.0, 1.0));
            float4 Reflection = pow(Fresnel0, _Density.xxxx);
            float4 SpeedMultiplier =_Time * _Speed.xxxx;
            float4 UV_Textured = float4((IN.uv_Texture.xyxy).x, (IN.uv_Texture.xyxy).y + SpeedMultiplier.x, (IN.uv_Texture.xyxy).z, (IN.uv_Texture.xyxy).w);
            float4 TilingMultiplier = UV_Textured * _Tile.xxxx;
            float4 Tex2D0=tex2D(_Texture, TilingMultiplier.xy);
			float4 TextureMultiplier = Tex2D0 * _Strength.xxxx;
            float4 ReflectionMultiplier = Reflection * TextureMultiplier;
            float4 ClampedReflection = ClampedStepReflection * ReflectionMultiplier;

            o.Alpha = ClampedReflection.w * _Color.a;
			o.Emission = ClampedReflection.xyz * _Color.rgb * texCUBE(_Cube, IN.worldRefl).xyz;
			#ifdef SHADER_API_D3D11
	
			#endif
		
			o.Albedo = 1;	
        }
        ENDCG
    }
    Fallback "Diffuse"
}
