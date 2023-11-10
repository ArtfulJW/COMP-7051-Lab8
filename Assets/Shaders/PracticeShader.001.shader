Shader"Custom/PracticeShader.001" {

    Properties{
        _Color("Color", Color) = (0,0,0,1)
        _MainTex("Texture", 2D) = "white" {}
    }

    SubShader{
        Pass{
            Tags{
                "RenderType" = "Opaque"
                "Queue" = "Geometry"
            }
                
            CGPROGRAM
            #include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag

            float4 _Color;
            sampler2D _MainTex;
            static half _Frequency = 10;
            static half _Amplitude = 0.1;

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
                
                
                /*
    
                https://www.ronja-tutorials.com/post/015-wobble-displacement/        
    
                float4 modVertex = v.vertex;
                modVertex.y += sin(v.vertex.x * _Time * _Frequency);
            
                float3 posPlusTangent = v.vertex + v.tangent * 0.01;
                posPlusTangent.y += sin(posPlusTangent.x * _Time * _Frequency);
                
                float3 biTangent = cross(v.tangent, v.normal);
                float3 posPlusbiTangent = v.vertex + v.tangent * 0.01;
                posPlusbiTangent.y += sin(posPlusbiTangent.x * _Time * _Frequency);
                
                float3 modifiedTangent = posPlusTangent - modVertex;
                float3 modifiedbiTangent = posPlusbiTangent - modVertex;
    
                float3 modifiedNormals = cross(modifiedTangent, modifiedbiTangent);
    
                v.normal = normalize(modifiedNormals);
                v.vertex = modVertex;
                */
                v.vertex.y = sin(v.vertex.x * _Time * _Frequency) / 5;
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            };

            // Fragment Shader (After Rasterizing). Output color per pixel
            float4 frag(v2f i) : SV_TARGET
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // Return Flat Red
                return col * _Color;
            }



            ENDCG
                
        }
    }

}
