Shader"Custom/SurfaceShader"
{
    Properties{
        _Color("Tint", Color) = (0,0,0,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Amplitude("Wave Size", Range(0,1)) = 0.4
        _Frequency("Wave Frequency", Range(1,1000)) = 2
        _AnimationSpeed ("Animation Speed", Range(0,20)) = 1
	    _Smoothness ("Smoothness", float) = 0
        _Metallic("Metallic", Range(0,100)) = 1

        [HDR] _Emission ("Emission", color) = (0,0,0)
        _FresnelColor ("Fresnel Color", Color) = (1,1,1,1)
        [PowerSlider(4)] _FresnelExponent ("Fresnel Exponent", Range(0.25, 20)) = 1
    }    

    SubShader{
        Tags{ "Queue" = "Transparent" "RenderType"="Transparent" }

        CGPROGRAM

        // Declaring the type of shader this will be to Unity.
        // Declaring the Vertex shader in this format vertex:VertexShaderName
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow alpha:fade

        sampler2D _MainTex;
        fixed4 _Color;

        float _Amplitude;
        float _Frequency;
        float _AnimationSpeed;
        float _Smoothness;
        half _Metallic;

        half3 _Emission;
        float3 _FresnelColor;
        float _FresnelExponent;

        struct Input
        {
            // uv_MainTex is specifically named such that it will already have the tiling and offset of the MainText Texture.
            float2 uv_MainTex;
    
            float3 worldNormal;
            float3 viewDir;
            INTERNAL_DATA
};

        // The Vertex Shader Function in Standard Surface Shaders is defined to: Accept 1 arguement of type; appdata_full. We then call it "data"
        void vert(inout appdata_full data)
        {
            // Note that if we manipulate the scale, we need to tell Unity to recalculate an extra shadow pass, addshadow (in pragma line).
            
            float4 modifiedPos = data.vertex;
            modifiedPos.y += sin(data.vertex.x * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;
    
            float3 posPlusTangent = data.vertex + data.tangent * 0.01;
            posPlusTangent.y += sin(posPlusTangent.x * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;

            float3 bitangent = cross(data.normal, data.tangent);
            float3 posPlusBitangent = data.vertex + bitangent * 0.01;
            posPlusBitangent.y += sin(posPlusBitangent.x * _Frequency + _Time.y * _AnimationSpeed) * _Amplitude;

            float3 modifiedTangent = posPlusTangent - modifiedPos;
            float3 modifiedBitangent = posPlusBitangent - modifiedPos;

            float3 modifiedNormal = cross(modifiedTangent, modifiedBitangent);
            data.normal = normalize(modifiedNormal);
            data.vertex = modifiedPos;
    
        }

        void surf(Input i, inout SurfaceOutputStandard o)
        {
            // Samples the 2D Texture of _MainTex at the given tiling and offset (From Input Struct)
            fixed4 col = tex2D(_MainTex, i.uv_MainTex);
            
            // 'Tint' the Sampled Color.
            col *= _Color;
    
            //get the dot product between the normal and the view direction
            float fresnel = dot(i.worldNormal, i.viewDir);
            //invert the fresnel so the big values are on the outside
            fresnel = saturate(1 - fresnel);
            //raise the fresnel value to the exponents power to be able to adjust it
            fresnel = pow(fresnel, _FresnelExponent);
            //combine the fresnel value with a color
            float3 fresnelColor = fresnel * _FresnelColor;
            //apply the fresnel value to the emission
            o.Emission = _Emission + fresnelColor;
    
            // Assign the Albedo to 'col'.
            o.Albedo = col.rgba;
            o.Alpha = col.a;
            o.Smoothness = _Smoothness;
            o.Metallic = _Metallic;
    
}

		ENDCG

    }
}
