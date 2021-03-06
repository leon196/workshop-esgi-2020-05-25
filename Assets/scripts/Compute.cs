﻿using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class Compute : MonoBehaviour
{
	public ComputeShader compute;
	public Transform target;

	private ComputeBuffer buffer;
	private Material material;

	struct Attribute {
		public Vector3 position;
		public Vector3 velocity;
		public Vector3 origin;
		public Vector3 normal;
	};
	private Attribute[] array;

	void Start ()
	{
		Mesh mesh = GetComponent<MeshFilter>().sharedMesh;
		Vector3[] vertices = mesh.vertices;
		Vector3[] normals = mesh.normals;
		array = new Attribute[vertices.Length];
		for (uint index = 0; index < array.Length; ++index) {
			array[index].position = vertices[index];
			array[index].velocity = Vector3.zero;
			array[index].origin = vertices[index];
			array[index].normal = normals[index];
		}

		buffer = new ComputeBuffer(array.Length, Marshal.SizeOf(typeof(Attribute)));
		buffer.SetData(array);

		compute.SetBuffer(0, "_Buffer", buffer);

		material = GetComponent<MeshRenderer>().sharedMaterial;
	}

	void Update ()
	{
		// only if unity editor (allowing hot reload shader)
		compute.SetBuffer(0, "_Buffer", buffer);
		compute.SetVector("_Target", target.position);
		compute.SetMatrix("_Matrix", transform.worldToLocalMatrix);

		compute.SetFloat("_Time", Time.time);
		compute.Dispatch(0, array.Length/8, 1, 1);
		material.SetBuffer("_Buffer", buffer);
	}

	void OnDestroy ()
	{
		if (buffer != null) buffer.Dispose();
	}
}
