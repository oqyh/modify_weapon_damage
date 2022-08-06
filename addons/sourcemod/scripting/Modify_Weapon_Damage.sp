#include <sourcemod>
#include <sdkhooks>

#define CFG_NAME "Modify_Weapon_Damage"

ConVar g_damage;
Handle g_modifyw;

char CfgFile[PLATFORM_MAX_PATH];
	
public Plugin:myinfo = 
{
	name = "Modify_Weapon_Damage",
	author = "Gold_KingZ",
	description = "Modify Any Weapon Damage",
	version = "1.0.0",
	url = "https://github.com/oqyh"
}

public OnPluginStart()
{
	Format(CfgFile, sizeof(CfgFile), "sourcemod/%s.cfg", CFG_NAME);
	g_modifyw = CreateConVar("sm_modify_weapon", "weapon_deagle", "which weapon do you want to modify damage https://github.com/oqyh/modify_weapons_damage/blob/main/List%20Of%20weapon_.txt");
	g_damage = CreateConVar( "sm_modify_damage", "300", "Damage Fist Deal  || 0= No Damage || 1= Lowest Damage || 300= 1 Hit");

	for (int i = 1; i < MaxClients; ++i)
		{
			if (IsClientInGame(i))
			{
				SDKHook(i, SDKHook_OnTakeDamage, OneHitDamage);
			}
		}
	LoadCfg();
}

void LoadCfg()
{
	AutoExecConfig(true, CFG_NAME);
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OneHitDamage);
}

public Action OneHitDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
    if (!attacker || attacker > MaxClients || !IsClientInGame(attacker))
    {
        return Plugin_Continue;
    }
	
    char sWeapon[32],hostname_name[128];
    GetConVarString(g_modifyw, hostname_name, sizeof(hostname_name));
    GetClientWeapon(attacker, sWeapon, sizeof(sWeapon));
    if(StrContains(sWeapon, hostname_name, false) != -1)
    {
        damage = g_damage.FloatValue;
		
        return Plugin_Changed;
    }
    return Plugin_Continue;
}