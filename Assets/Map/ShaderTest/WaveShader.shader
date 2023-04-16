Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Height ("Wave Height",Range(0,2)) = 0.3
        _Frequency ("Frequency",Range(0,1.55)) = 1
        _Offset ("Offset",Range(0,5)) = 1

        [HDR] _CutoffColor("Cutoff Color", Color) = (1,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct appdata members worldPos)
#pragma exclude_renderers d3d11
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                //float3 worldPos;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Height;
            float _Frequency;
            float _Offset;
            float4 _Plane;
            float4 _CutoffColor;

            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.x += sin(v.vertex.y * _Frequency + _Offset)*_Height;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {


                float distance = dot(i.vertex, _Plane.xyz);
                distance = distance +_Plane.w;

                clip(-distance);

                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);


                return col;
            }
            ENDCG
        }
    }
}
