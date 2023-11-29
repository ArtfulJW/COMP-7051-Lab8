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

            sampler2D _MainTex;
            float4 _FogColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            // Vertex Shader
            v2f vert(appdata v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            };

            // Fragment Shader (After Rasterizing). Output color per pixel
            float4 frag(v2f i) : SV_TARGET
            {
    
    // Calculate the Distance from point in World Space to Camera
                float dist = length(_WorldSpaceCameraPos - i.position);
    
                fixed4 col = tex2D(_MainTex, i.uv);
                // Return Flat Red
                return col * _FogColor;
            }

            ENDCG

        }
    }
}
