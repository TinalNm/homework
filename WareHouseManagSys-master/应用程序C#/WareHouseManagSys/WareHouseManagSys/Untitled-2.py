string ip = "192.168.30.130";
string mask = "255.255.255.128";

string[] ipParts = ip.Split('.');
string[] maskParts = mask.Split('.');

string networkNumber = "";
for (int i = 0; i < 4; i++)
{
    int ipPart = int.Parse(ipParts[i]);
    int maskPart = int.Parse(maskParts[i]);
    networkNumber += (ipPart & maskPart).ToString();
    if (i != 3)
    {
        networkNumber += ".";
    }
}

Console.WriteLine("网络号是: " + networkNumber);