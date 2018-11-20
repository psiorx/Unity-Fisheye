// Copyright Massachusetts Institute of Technology 2018

 Shader "Custom/RenderFisheye"
 {

    Properties
    {
        _Cube ("Reflection Map", Cube) = "" {}
        _Alpha ("Double Sphere Alpha", float) = 2.0
        _Chi ("Double Sphere Chi", float) = 2.0
        _FocalLength ("Double Sphere Focal Length", float) = 1.0
    }

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0
            
            #include "UnityCG.cginc"

            uniform samplerCUBE _Cube;
            uniform float _Alpha;
            uniform float _Chi;
            uniform float _FocalLength;

            struct v2f {
                float2 uv : TEXCOORD2;
                float4 pos : SV_POSITION;
            };



            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, uv);
                return o;
            }
            
            // The Double Sphere Camera Model (V. Usenko, N. Demmel, 
            //   D. Cremers), In Proc. of the Int. Conference on 3D 
            //   Vision (3DV), 2018
            
            fixed4 frag (v2f i) : SV_Target
            {
                float cx = 0.5;
                float cy = 0.5;
                float fx = _FocalLength;
                float fy = _FocalLength;
                float alpha = _Alpha;
                float chi = _Chi;

                float mx = (i.uv.x - cx) / fx;
                float my = (i.uv.y - cy) / fy;

                float r2 = mx * mx + my * my;
                float beta1 = 1 - (2 * alpha - 1) * r2;
                if(beta1 < 0) {
                    return float4(0, 0, 0, 1);
                }                
                float mz = (1 - alpha * alpha * r2) / (alpha * sqrt(beta1) + 1 - alpha);

                float beta2 = mz * mz + (1 - chi * chi) * r2;

                if(beta2 < 0) {
                    return float4(0, 0, 0, 1);
                }

                float3 fisheye_ray = (mz * chi + sqrt(mz * mz + (1 - chi * chi) * r2)) / (mz * mz + r2) * float3(mx, my, mz) - float3(0, 0, chi);

                return texCUBE(_Cube, mul((float3x3)unity_CameraToWorld, normalize(fisheye_ray)));
            }
            ENDCG
        }
}
 }
