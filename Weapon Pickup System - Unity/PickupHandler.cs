using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickupHandler : MonoBehaviour
{
    [SerializeField] private Camera mainCamera;
    [SerializeField] private Weapon[] weaponSlots;
    [SerializeField] private Transform weaponParent;

    private bool AllSlotsFull()
    {
        for (int i = 0; i < weaponSlots.Length; i++)
        {
            if(weaponSlots[i] == null) return false;
        }
        return true;
    }
    
    private void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            CheckForWeapon();
        }
    }

    private void CheckForWeapon()
    {
            if(Physics.Raycast(mainCamera.transform.position, mainCamera.transform.forward, out RaycastHit raycastHit, 5f))
            {
                if(raycastHit.collider.TryGetComponent(out WeaponPickup weaponPickup))
                {
                    Weapon weapon = weaponPickup.Use();

                    for (int i = 0; i < weaponSlots.Length; i++)
                    {
                        if(weaponSlots[i] == null)
                        {
                            SetWeapon(weapon,i);
                            break;
                        }
                        else if(AllSlotsFull())
                        {
                            weaponSlots[i].Drop(mainCamera.transform.forward * 7f);
                            SetWeapon(weapon,i);
                            break;
                        }
                    }
                }
            }
    }

    private void SetWeapon(Weapon weapon, int i)
    {
        weapon.transform.SetParent(weaponParent);
        weapon.transform.localPosition = Vector3.zero;
        weapon.transform.localRotation = Quaternion.Euler(Vector3.zero);
        weapon.transform.localScale = Vector3.one;
        weaponSlots[i] = weapon;
    }
}
