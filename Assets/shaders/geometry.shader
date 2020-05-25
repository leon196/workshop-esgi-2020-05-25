Shader "Unlit/Geometry"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size ("Size", Float) = 0.4
        _CameraRangeMin ("_CameraRangeMin", Float) = 0.1
        _CameraRangeMax ("_CameraRangeMax", Float) = 2.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct attribute
            {
                float4 position : POSITION;
                float3 normal : NORMAL;
                float2 texcoord : TEXCOORD0;
                uint id : SV_VertexID;
            };

            struct varyingGeometry
            {
                float2 texcoord : TEXCOORD0;
                float3 normal : NORMAL;
                float4 position : SV_POSITION;
            };

            struct varying
            {
                float2 texcoord : TEXCOORD0;
                float4 position : SV_POSITION;
            };

            uniform sampler2D _MainTex;
            uniform float _Size, _CameraRangeMin, _CameraRangeMax;

            #ifdef SHADER_API_D3D11
            struct Attribute {
				float3 position;
				float3 velocity;
				float3 origin;
				float3 normal;
            };
            StructuredBuffer<Attribute> _Buffer;
            #endif

            varyingGeometry vert (attribute v)
            {
                varyingGeometry o;
                o.position = v.position;
            	#ifdef SHADER_API_D3D11
            	o.position.xyz = _Buffer[v.id].position;
            	#endif
                o.texcoord = v.texcoord;
                o.normal = v.normal;
                return o;
            }

            [maxvertexcount(32)]
            void geom (triangle varyingGeometry input[3], inout TriangleStream<varying> stream)
            {
            	varyingGeometry v = input[0];
            	varying o;
            	o.position = v.position;
            	o.texcoord = v.texcoord;
            	varying origin;
            	origin.position = UnityObjectToClipPos(v.position + float4(v.normal * 0.01, 0));
            	origin.texcoord = v.texcoord;
            	float3 c = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1));
            	// float d = length(_WorldSpaceCameraPos - mul(UNITY_MATRIX_M, v.position).xyz);
            	float3 z = normalize(c - v.position.xyz);
            	// float3 z = v.normal;
            	float3 x = normalize(cross(z,float3(0,1,0)));
            	float3 y = normalize(cross(z,x));
            	float angle = 0;
            	float count = 8.0;// + 4.0 * smoothstep(_CameraRangeMin, _CameraRangeMax, d);
            	for (uint index = 0; index < uint(count); ++index) {
            		o.position = UnityObjectToClipPos(v.position + float4(x * cos(angle) + y * sin(angle), 0) * _Size);
            		stream.Append(o);

            		angle += 6.28/float(count);
            		o.position = UnityObjectToClipPos(v.position + float4(x * cos(angle) + y * sin(angle), 0) * _Size);
            		stream.Append(o);

	            	stream.Append(origin);
	            	stream.RestartStrip();
            	}
            }

            fixed4 frag (varying i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.texcoord);
                return color;
            }
            ENDCG
        }
    }
}
