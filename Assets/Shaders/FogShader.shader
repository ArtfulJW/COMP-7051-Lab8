// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader"Custom/FogShader"{

    Properties{
        _FogColor ("Fog Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

            sampler2D _MainTex, _CameraDepthTexture;
            float4 _FogColor;
            float dist;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
                float depth : SV_Depth;
            };

            // Vertex Shader
            v2f vert(appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.depth = o.position.w;
                o.uv = v.uv;
                return o;
            };

            // Fragment Shader (After Rasterizing). Output color per pixel
            float4 frag(v2f i) : SV_TARGET
            {
                #ifdef UNITY_REVERSED_Z
                #define DEPTH_MAX 0.0f
                #define DEPTH_MIN 1.0f
                #else
                #define DEPTH_MAX 1.0f
                #define DEPTH_MIN 0.0f
                #endif
                // Calculate the Distance from point in World Space to Camera
                //float dist = distance(_WorldSpaceCameraPos, i.position);
    
                // Unity Macro for Fog Calculation
                // UNITY_CALC_FOG_FACTOR_RAW(dist);
    
                fixed4 col = tex2D(_MainTex, i.uv);
                //dist = length(i.position - _WorldSpaceCameraPos);
    
                //float linearDepth = 1.0 - saturate((1250 - dist) / (1250 - 330));
    
                //col = lerp(_FogColor, col, linearDepth);
    
                float dist = length(_WorldSpaceCameraPos - i.position);

                col = lerp(_FogColor+col, col, (1-(dist + _ProjectionParams.z) / (_ProjectionParams.z - _ProjectionParams.y)));
                col += lerp(_FogColor+col, col, (1-(_ProjectionParams.z - dist) / (_ProjectionParams.z - _ProjectionParams.y)));
                return col;
}

            ENDCG

        }
    }
}
