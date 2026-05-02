using UnityEngine;

public class DebugNormals : MonoBehaviour
{
    [field:SerializeField]
    public MeshFilter MeshFilter { get; set; }

    [field: SerializeField]
    public float GizmosScale { get; set; } = 1;

    private void OnDrawGizmos()
    {
        if (MeshFilter == null)
            return;

        Vector3[] positions = MeshFilter.sharedMesh.vertices;
        Vector3[] normals = MeshFilter.sharedMesh.normals;
        int count = MeshFilter.sharedMesh.vertices.Length;
        for (int i = 0; i < count; i++)
        {
            Vector3 position = positions[i];
            Vector3 normal = normals[i]; 
            Vector3 worldNormal = transform.TransformDirection(normal);
            Vector3 start = transform.TransformPoint(position);
            Vector3 end = start + worldNormal * GizmosScale;
            Vector3 colorV = worldNormal * 0.5f + Vector3.one * 0.5f;
            Color color = new(colorV.x, colorV.y, colorV.z, 1);
            Gizmos.color = color;
            Gizmos.DrawLine(start, end);
        }
    }

    private void OnValidate()
    {
        if (MeshFilter == null)
            MeshFilter = GetComponent<MeshFilter>();
    }
}
