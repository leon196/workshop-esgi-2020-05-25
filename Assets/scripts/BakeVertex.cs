using System.Linq;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Using lines from Keijiro Takahashi
// https://github.com/keijiro/Skinner/blob/master/Assets/Skinner/SkinnerModel.cs
// https://github.com/keijiro/Skinner/blob/master/Assets/Skinner/SkinnerSource.cs

public class BakeVertex : MonoBehaviour
{
	private RenderTexture texture;
	private Camera cam;

	void Start () {
		SkinnedMeshRenderer skin = GetComponent<SkinnedMeshRenderer>();
		Mesh mesh = skin.sharedMesh;
		int count = mesh.vertices.Length;
		int[] indices = Enumerable.Range(0, count).ToArray();
		List<Vector2> uv = Enumerable.Range(0, count).Select(i => Vector2.right * (i + 0.5f) / count).ToList();
		Mesh meshClone = Instantiate<Mesh>(mesh);
		meshClone.SetUVs(0, uv);
		meshClone.SetIndices(indices, MeshTopology.Points, 0);
		meshClone.UploadMeshData(true);
		skin.sharedMesh = meshClone;

		texture = new RenderTexture(count, 1, 0, RenderTextureFormat.ARGBFloat);
		texture.filterMode = FilterMode.Point;
		texture.Create();

		GameObject go = new GameObject("Camera");
		go.hideFlags = HideFlags.HideInHierarchy;
		cam = go.AddComponent<Camera>();
		cam.enabled = false;
		cam.renderingPath= RenderingPath.Forward;
		cam.clearFlags = CameraClearFlags.SolidColor;
		cam.depth = -10000;
		cam.nearClipPlane = -100;
		cam.farClipPlane = 100;
		cam.orthographic = true;
		cam.orthographicSize = 100;
		cam.targetTexture = texture;

		CullingStateController culler = go.AddComponent<CullingStateController>();
		culler.target = skin;
	}

	void LateUpdate () {
		cam.Render();
	}
}
