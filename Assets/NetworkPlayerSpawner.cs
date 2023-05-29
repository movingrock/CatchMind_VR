using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class NetworkPlayerSpawner : MonoBehaviourPunCallbacks
{
    private GameObject spawnedPlayerPrefab;

    public override void OnJoinedRoom()
    {
        base.OnJoinedRoom();
        Vector3 spawnedPos = new Vector3(-3, 1, 3);
        Quaternion spawnedRot = new Quaternion(0, 0, 0, 0);
        spawnedPlayerPrefab = PhotonNetwork.Instantiate("Network Player", spawnedPos, transform.rotation); // 생성 위치랑 각도 설정 가능
        //spawnedPlayerPrefab = PhotonNetwork.Instantiate("Network Player", transform.position, transform.rotation);
    }

    public override void OnLeftRoom()
    {
        base.OnLeftRoom();
        PhotonNetwork.Destroy(spawnedPlayerPrefab);
    }
}
