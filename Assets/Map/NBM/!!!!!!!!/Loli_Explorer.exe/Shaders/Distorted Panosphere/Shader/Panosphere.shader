// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Loli_Explorer.exe/Pano Sphere"
{
	Properties
	{
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		[Toggle]_UseCubemap("Use Cubemap?", Float) = 0
		[HDR]_CubemapColor("Cubemap Color", Color) = (1,1,1,1)
		_CubemapContrast("Cubemap Contrast", Float) = 1
		_Cubemap("Cubemap", CUBE) = "black" {}
		_CubemapPower("Cubemap Power", Range( 0 , 1)) = 0
		_MainTex("MainTex", 2D) = "black" {}
		[HDR]_PanoColor("Pano Color", Color) = (1,1,1,1)
		_Contrast("Contrast", Float) = 1
		_ScaleX("Scale X", Float) = 1
		_ScaleY("Scale Y", Float) = 1
		_OffsetX("Offset X", Float) = 0
		_OffsetY("Offset Y", Float) = 0
		_PanoTex("Pano Tex", 2D) = "white" {}
		_SpeedX("Speed X", Range( -1 , 1)) = 0
		_SpeedY("Speed Y", Range( -1 , 1)) = 0
		_DistortionTexture("Distortion Texture", 2D) = "white" {}
		_DistortionPower("Distortion Power", Range( 0 , 0.1)) = 0
		_OutlineColor("Outline Color", Color) = (1,1,1,1)
		_Width("Width", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float outlineVar = _Width;
			v.vertex.xyz *= ( 1 + outlineVar);
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _OutlineColor.rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			float3 worldNormal;
			float3 worldRefl;
			INTERNAL_DATA
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _PanoTex;
		uniform float _SpeedX;
		uniform float _SpeedY;
		uniform sampler2D _DistortionTexture;
		uniform float4 _DistortionTexture_ST;
		uniform float _DistortionPower;
		uniform float _ScaleX;
		uniform float _ScaleY;
		uniform float _OffsetX;
		uniform float _OffsetY;
		uniform float _Contrast;
		uniform float4 _PanoColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _UseCubemap;
		uniform float _Smoothness;
		uniform float _Metallic;
		uniform samplerCUBE _Cubemap;
		uniform float _CubemapPower;
		uniform float4 _CubemapColor;
		uniform float _CubemapContrast;
		uniform float _Width;
		uniform float4 _OutlineColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 Outline165 = 0;
			v.vertex.xyz += Outline165;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldNormal = i.worldNormal;
			Unity_GlossyEnvironmentData g183 = UnityGlossyEnvironmentSetup( _Smoothness, data.worldViewDir, ase_worldNormal, float3(0,0,0));
			float3 indirectSpecular183 = UnityGI_IndirectSpecular( data, _Metallic, ase_worldNormal, g183 );
			float3 Specular185 = indirectSpecular183;
			float4 temp_cast_6 = (0.0).xxxx;
			float3 ase_worldReflection = i.worldRefl;
			float4 lerpResult202 = lerp( temp_cast_6 , texCUBE( _Cubemap, ase_worldReflection ) , _CubemapPower);
			float4 temp_cast_7 = (_CubemapContrast).xxxx;
			float4 CubeMap195 = pow( ( lerpResult202 * _CubemapColor ) , temp_cast_7 );
			float4 CubemapSwitch199 = (( _UseCubemap )?( CubeMap195 ):( float4( Specular185 , 0.0 ) ));
			c.rgb = CubemapSwitch199.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float2 appendResult126 = (float2(_SpeedX , _SpeedY));
			float2 PanValue176 = appendResult126;
			float4 temp_cast_0 = (1.0).xxxx;
			float2 uv0_DistortionTexture = i.uv_texcoord * _DistortionTexture_ST.xy + _DistortionTexture_ST.zw;
			float2 panner172 = ( _Time.y * ( PanValue176 * 0.5 ) + uv0_DistortionTexture);
			float2 DistUV174 = panner172;
			float4 lerpResult145 = lerp( temp_cast_0 , tex2D( _DistortionTexture, DistUV174 ) , _DistortionPower);
			float2 appendResult71 = (float2(( atan2( i.viewDir.z , i.viewDir.x ) * 0.3185 ) , ( acos( i.viewDir.y ) / -( 0.9 * UNITY_PI ) )));
			float2 Panosphere132 = (( 1.0 - appendResult71 )).xy;
			float4 Distortion139 = ( lerpResult145 * float4( Panosphere132, 0.0 , 0.0 ) );
			float2 panner125 = ( _Time.y * PanValue176 + Distortion139.rg);
			float2 Paning136 = panner125;
			float2 appendResult116 = (float2(_ScaleX , _ScaleY));
			float2 appendResult117 = (float2(_OffsetX , _OffsetY));
			float4 temp_cast_3 = (_Contrast).xxxx;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 PanoTex123 = ( ( pow( tex2D( _PanoTex, (Paning136*appendResult116 + appendResult117) ) , temp_cast_3 ) * _PanoColor ) + tex2D( _MainTex, uv_MainTex ) );
			o.Emission = PanoTex123.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
37;8;1666;929;3854.683;-2417.108;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;131;-3568.712,-151.8809;Inherit;False;1369.115;481.5604;Comment;8;176;154;126;135;125;128;127;136;Panning;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-3559.007,119.3007;Inherit;False;Property;_SpeedY;Speed Y;16;0;Create;True;0;0;False;0;0;-0.01;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-3553.007,-7.699329;Inherit;False;Property;_SpeedX;Speed X;15;0;Create;True;0;0;False;0;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;122;-3584.478,-854.5471;Inherit;False;1651.44;639.8665;Comment;12;132;73;72;71;65;112;113;67;76;64;63;61;Pano UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;126;-3290.007,47.30059;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;-3102.853,9.292297;Inherit;False;PanValue;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;175;-3606.184,1433.449;Inherit;False;939.4731;510.9343;;7;170;172;173;174;177;190;191;Dist UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;61;-3534.478,-759.8499;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PiNode;63;-3338.282,-491.1925;Inherit;False;1;0;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;67;-3098.282,-663.1925;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-3466.483,1744.44;Inherit;False;Constant;_Float2;Float 2;16;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-3167.106,-804.5471;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;False;0;0.3185;0.3185;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;64;-3125.282,-459.1925;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ACosOpNode;76;-3106.002,-540.3834;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;177;-3515.853,1637.292;Inherit;False;176;PanValue;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-3300.483,1635.44;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;173;-3521.859,1483.449;Inherit;False;0;138;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;65;-2957.282,-497.1925;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;170;-3276.305,1834.383;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-2951.106,-735.5471;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;71;-2779.282,-618.1925;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;172;-3109.092,1593.971;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;72;-2626.282,-601.1925;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;140;-3582.12,387.8862;Inherit;False;1150;525;Comment;8;141;139;142;138;144;145;146;178;Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-2909.711,1598.827;Inherit;False;DistUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;73;-2445.806,-612.2842;Inherit;False;True;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-3510.558,520.6724;Inherit;False;174;DistUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-3149.12,429.8861;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-2163.387,-619.897;Inherit;False;Panosphere;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-3269.708,694.3259;Inherit;False;Property;_DistortionPower;Distortion Power;18;0;Create;True;0;0;False;0;0;0.0183;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;138;-3288.12,498.8862;Inherit;True;Property;_DistortionTexture;Distortion Texture;17;0;Create;True;0;0;False;0;-1;None;05ee686db4a109445980f2071f35efb1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;145;-2963.708,433.3259;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-2988.12,571.8861;Inherit;False;132;Panosphere;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-2781.12,444.8861;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-2636.12,426.8862;Inherit;False;Distortion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;154;-3078.128,213.9501;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;-3047.008,-95.44863;Inherit;False;139;Distortion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;194;-3579.483,2532.44;Inherit;False;1358;458;Comment;10;195;202;203;193;204;192;205;206;207;208;Cubemap;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;125;-2804.915,-90.46223;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;133;-3584.705,-1385.708;Inherit;False;1806.415;495.4349;Comment;16;123;158;156;129;130;1;114;134;117;116;118;120;121;119;160;161;Pano Tex;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldReflectionVector;192;-3529.483,2604.44;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;118;-3565.105,-1261.689;Inherit;False;Property;_ScaleX;Scale X;10;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-3545.105,-1082.689;Inherit;False;Property;_OffsetX;Offset X;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-3562.105,-1179.689;Inherit;False;Property;_ScaleY;Scale Y;11;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-3540.105,-987.6882;Inherit;False;Property;_OffsetY;Offset Y;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;203;-3179.683,2772.108;Inherit;False;Constant;_Float3;Float 3;18;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;193;-3285.483,2582.44;Inherit;True;Property;_Cubemap;Cubemap;5;0;Create;True;0;0;False;0;-1;None;bdacfd9f6f4de4258861691d7ade2864;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-2590.093,-95.6335;Inherit;False;Paning;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;204;-3253.683,2845.108;Inherit;False;Property;_CubemapPower;Cubemap Power;6;0;Create;True;0;0;False;0;0;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;202;-2964.683,2710.108;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;184;-3591.268,2069.245;Inherit;False;924;438;;4;183;185;186;188;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;206;-2946.683,2822.108;Inherit;False;Property;_CubemapColor;Cubemap Color;3;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1.498039,1.498039,1.498039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;134;-3401.527,-1333.819;Inherit;False;136;Paning;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;116;-3369.55,-1217;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;117;-3372.55,-1123;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-2739.683,2879.108;Inherit;False;Property;_CubemapContrast;Cubemap Contrast;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;114;-3140.34,-1287.7;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-3562.484,2414.44;Inherit;False;Property;_Metallic;Metallic;1;0;Create;True;0;0;False;0;0;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-3576.484,2318.355;Inherit;False;Property;_Smoothness;Smoothness;0;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;-2722.683,2669.108;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-2923.537,-1350.314;Inherit;True;Property;_PanoTex;Pano Tex;14;0;Create;True;0;0;False;0;-1;None;733dcbaf149ccb442a4c2dcb681c04d8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectSpecularLight;183;-3254.268,2146.245;Inherit;True;World;3;0;FLOAT3;0,0,1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;161;-2812.42,-1159.384;Inherit;False;Property;_Contrast;Contrast;9;0;Create;True;0;0;False;0;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;207;-2566.683,2712.108;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;195;-2453.483,2589.44;Inherit;False;CubeMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;166;-3562.193,971.0492;Inherit;False;876;379;Comment;4;162;164;163;165;Outline;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;185;-2927.484,2157.355;Inherit;False;Specular;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;130;-2848.249,-1081.693;Inherit;False;Property;_PanoColor;Pano Color;8;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;200;-3565.483,3012.44;Inherit;False;885;303;;4;197;198;196;199;CubemapSwitch;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;160;-2549.42,-1343.384;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-3507.193,1235.049;Inherit;False;Property;_Width;Width;20;0;Create;True;0;0;False;0;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;-3500.483,3062.44;Inherit;False;185;Specular;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-2415.304,-1250.165;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;156;-2560.027,-1085.895;Inherit;True;Property;_MainTex;MainTex;7;0;Create;True;0;0;False;0;-1;None;2c4ce30847e945e46b26010b0cc1925f;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;198;-3515.483,3200.44;Inherit;False;195;CubeMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;163;-3512.193,1021.049;Inherit;False;Property;_OutlineColor;Outline Color;19;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;158;-2213.721,-1135.15;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;196;-3241.483,3129.44;Inherit;False;Property;_UseCubemap;Use Cubemap?;2;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;162;-3221.637,1073.796;Inherit;False;1;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-1976.415,-1295.84;Inherit;False;PanoTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;199;-2934.483,3129.44;Inherit;False;CubemapSwitch;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;165;-2929.193,1094.049;Inherit;False;Outline;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-823.499,-572.6182;Inherit;False;123;PanoTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-875.7627,-397.3055;Inherit;False;199;CubemapSwitch;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;-826.2296,-295.1183;Inherit;False;165;Outline;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-599.886,-612.0253;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;.Loli_Explorer.exe/Pano Sphere;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Spherical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;126;0;127;0
WireConnection;126;1;128;0
WireConnection;176;0;126;0
WireConnection;67;0;61;3
WireConnection;67;1;61;1
WireConnection;64;0;63;0
WireConnection;76;0;61;2
WireConnection;190;0;177;0
WireConnection;190;1;191;0
WireConnection;65;0;76;0
WireConnection;65;1;64;0
WireConnection;112;0;67;0
WireConnection;112;1;113;0
WireConnection;71;0;112;0
WireConnection;71;1;65;0
WireConnection;172;0;173;0
WireConnection;172;2;190;0
WireConnection;172;1;170;0
WireConnection;72;0;71;0
WireConnection;174;0;172;0
WireConnection;73;0;72;0
WireConnection;132;0;73;0
WireConnection;138;1;178;0
WireConnection;145;0;144;0
WireConnection;145;1;138;0
WireConnection;145;2;146;0
WireConnection;142;0;145;0
WireConnection;142;1;141;0
WireConnection;139;0;142;0
WireConnection;125;0;135;0
WireConnection;125;2;176;0
WireConnection;125;1;154;0
WireConnection;193;1;192;0
WireConnection;136;0;125;0
WireConnection;202;0;203;0
WireConnection;202;1;193;0
WireConnection;202;2;204;0
WireConnection;116;0;118;0
WireConnection;116;1;119;0
WireConnection;117;0;121;0
WireConnection;117;1;120;0
WireConnection;114;0;134;0
WireConnection;114;1;116;0
WireConnection;114;2;117;0
WireConnection;205;0;202;0
WireConnection;205;1;206;0
WireConnection;1;1;114;0
WireConnection;183;1;186;0
WireConnection;183;2;188;0
WireConnection;207;0;205;0
WireConnection;207;1;208;0
WireConnection;195;0;207;0
WireConnection;185;0;183;0
WireConnection;160;0;1;0
WireConnection;160;1;161;0
WireConnection;129;0;160;0
WireConnection;129;1;130;0
WireConnection;158;0;129;0
WireConnection;158;1;156;0
WireConnection;196;0;197;0
WireConnection;196;1;198;0
WireConnection;162;0;163;0
WireConnection;162;1;164;0
WireConnection;123;0;158;0
WireConnection;199;0;196;0
WireConnection;165;0;162;0
WireConnection;0;2;124;0
WireConnection;0;13;187;0
WireConnection;0;11;167;0
ASEEND*/
//CHKSM=19543A0C21286B96D9FC99043FDE773D9F54F203