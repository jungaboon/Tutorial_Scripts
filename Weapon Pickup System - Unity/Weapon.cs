using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Weapon : MonoBehaviour
{
    [SerializeField] private string weaponName;
    public string GetName {get {return weaponName;}}

    [SerializeField] private WeaponPickup weaponDrop;

    public void Drop(Vector3 dir)
    {
        WeaponPickup weaponPickup = Instantiate(weaponDrop, transform.position, Quaternion.identity);
        weaponPickup.Spawn(dir);
        Destroy(gameObject);
    }
}
