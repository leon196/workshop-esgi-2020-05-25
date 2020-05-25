
using System;
using System.IO;
using System.Reflection;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(MeshFilter))]
public class MeshFilterEditor : Editor
{
	public override void OnInspectorGUI ()
	{
		serializedObject.Update();
		DrawDefaultInspector();
		MeshFilter script = (MeshFilter)target;
	}

	// Avoid big file unity scene by saving generated mesh in asset folder
	void SaveMesh (MeshFilter meshFilter)
	{
		string filepath = "Assets/meshes/"+meshFilter.gameObject.name+".mesh";
		AssetDatabase.CreateAsset(meshFilter.sharedMesh, filepath);
		AssetDatabase.SaveAssets();
		AssetDatabase.Refresh();
		meshFilter.mesh = (Mesh)AssetDatabase.LoadAssetAtPath(filepath, typeof(Mesh));
	}
}