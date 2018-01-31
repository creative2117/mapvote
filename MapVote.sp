#include <sourcemod>

public Plugin:myinfo =
{
	name = "MapVote",
	author = "Creative",
	description = "vote if you like the map or not",
	version = "1.0",
	url = ""
}

static String:KVPath2[2000];
static String:storemap[MAX_NAME_LENGTH];
static String:SteamID[MAX_NAME_LENGTH];
static String:ClientName[MAX_NAME_LENGTH];

public OnPluginStart()
{
	RegConsoleCmd("sm_kalle", vote);
	
	CreateDirectory("addons/sourcemod/data/StoreClientVotes", 3);
	BuildPath(Path_SM, KVPath2, sizeof(KVPath2), "data/StoreClientVotes/ClientVotes.txt");
}

public Action:vote(client, args)
{
	GetClientAuthId(client, AuthId_Steam2, SteamID, sizeof(SteamID));

	new Handle:MapVote = CreateMenu(MenuHandler);
	SetMenuTitle(MapVote, "Gillar du denna mappen? \n");
	AddMenuItem(MapVote, "ja", "Ja.");
	AddMenuItem(MapVote, "nej", "Nej.");
	DisplayMenu(MapVote, client, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

public OnClientAuthorized(client)
{
	GetClientName(client, ClientName, sizeof(ClientName));
}

public OnMapStart()
{
	GetCurrentMap(storemap, sizeof(storemap));
}

public MenuHandler(Handle:MapVote, MenuAction:action, client, item)
{
	if(action == MenuAction_Select)
	{
		new Handle:StoreClientVotes = StoreClientVotes = CreateKeyValues("ClientVotes");
		FileToKeyValues(StoreClientVotes, KVPath2);
		
		
		new String:info[32];
		GetMenuItem(MapVote, item, info, sizeof(info));
		
		if(StrEqual(info, "nej"))
		{
			if(KvJumpToKey(StoreClientVotes, SteamID, true))
			{
				KvSetString(StoreClientVotes, "name", ClientName);
				KvSetString(StoreClientVotes, storemap, "nej");
				KvRewind(StoreClientVotes);
			}
		}
		else if(StrEqual(info, "ja"))
		{
			if(KvJumpToKey(StoreClientVotes, SteamID, true))
			{
				KvSetString(StoreClientVotes, "name", ClientName);
				KvSetString(StoreClientVotes, storemap, "ja");
				KvRewind(StoreClientVotes);
			}
		}
		KeyValuesToFile(StoreClientVotes, KVPath2);
		CloseHandle(StoreClientVotes);
	}
}