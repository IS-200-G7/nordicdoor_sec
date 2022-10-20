using Microsoft.AspNetCore.Mvc;
using PDSA_System.Server.Models;
using Dapper;
using MySql.Data.MySqlClient;
using Org.BouncyCastle.Asn1.Pkcs;

namespace PDSA_System.Server.Controllers;


[Route("/api/[controller]")]
[ApiController]
public class ForslagController : Controller
{

    private readonly IConfiguration _configuration;

    public ForslagController(IConfiguration configuration)
    {
        this._configuration = configuration;
    }


    /**
     * Henter alle Forslag fra databasen.
     * Returnerer statuskode 200 dersom det ikke oppstår feil.
     */
    [HttpGet]
    public async Task<ActionResult<List<Forslag>>> GetAllForslag()
    {
        var connString = _configuration.GetValue<string>("ConnectionStrings:DefaultConnection");
        using var conn = new DbHelper(connString).Connection;

        var forslag = await conn.QueryAsync<Forslag>("SELECT * FROM Forslag");

        return Ok(forslag);
    }

    /**
     * Funksjon for å hente ut spesifikke forslag
     * Returnerer statuskode 200 dersom det ikke oppstår feil.
     */
    [HttpGet("/api/[controller]/{forslagId}")]
    public async Task<ActionResult<List<Forslag>>> GetForslag(int forslagId)
    {
        var connString = _configuration.GetValue<string>("ConnectionStrings:DefaultConnection");
        using var conn = new DbHelper(connString).Connection;

        var forslag = await conn.QueryAsync<Forslag>("SELECT * FROM Forslag WHERE ForslagId = @id",
            new { id = forslagId });

        return Ok(forslag);
    }

    /**
    * Funksjon for å opprette forslag
    * Returnerer statuskode 200 dersom det ikke oppstår feil.
    * Fjernet bilde da det ikke fungerte å legge til pga kluss med datatype
    * Hvis den skal testes i swagger fjern bilde stringen og kjør
     */
    [HttpPost("/api/[controller]/createforslag/")]
    public async Task<ActionResult<List<Forslag>>> CreateForslag(Forslag forslag)
    {
        //byte[] bilde = GetBilde("C:/Bjønn.jpeg");

        var connString = _configuration.GetValue<string>("ConnectionStrings:DefaultConnection");
        using var conn = new DbHelper(connString).Connection;

        await conn.ExecuteAsync("INSERT INTO Forslag (ForfatterId, TeamId, Emne, Beskrivelse, Kategori) VALUES (@ForfatterId, @TeamId, @Emne, @Beskrivelse, @Kategori)", forslag);

        return Ok(await GetAllForslag());
    }

    /**
     * Funksjon for å oppdatere forslag
     * Returnerer statuskode 200 dersom det ikke oppstår feil.
     * Funker ikke helt enda.
     */
    [HttpPut("/api/[controller]/updateforslag/{forslagId}")]
    public async Task<ActionResult<List<Forslag>>> UpdateForslag(int forslagId, Forslag forslag)
    {
        var connString = _configuration.GetValue<string>("ConnectionStrings:DefaultConnection");
        using var conn = new DbHelper(connString).Connection;

        await conn.ExecuteAsync(
            "UPDATE Forslag SET ForfatterId = @ForfatterId, TeamId = @TeamId, Emne = @Emne, Beskrivelse = @Beskrivelse, Bilde = @Bilde, Kategori = @Kategori WHERE ForslagId = @ForslagId",
            forslag);

        return Ok(await GetAllForslag());
    }

    /**
     * Funksjon for å slette forslag utifra forslagId
     * Returnerer statuskode 200 dersom det ikke oppstår feil
     */
    [HttpDelete("/api/[controller]/deleteforslag/{forslagId}")]
    public async Task<ActionResult<List<Forslag>>> DeleteForslag(int forslagId)
    {
        var connString = _configuration.GetValue<string>("ConnectionStrings:DefaultConnection");
        using var conn = new DbHelper(connString).Connection;

        await conn.ExecuteAsync("DELETE FROM Forslag WHERE ForslagId = @id", new { id = forslagId });

        return Ok(await GetAllForslag());
    }

    // status controller
    [HttpPost("/api/[controller]/setstatus/")]
    public async Task<ActionResult<List<Forslag>>> SetStatus([FromQuery] int ForslagId, [FromQuery] string Status)
    {   // Hente til connection string fra appsettings.json og åpne en connection til database
        var connString = _configuration.GetValue<string>("ConnectionStrings:DefaultConnection");
        using var conn = new DbHelper(connString).Connection;
        conn.Open();

        // En array med statuser som er lov å bruke
        string[] acceptedStatuses = { "plan", "do", "study", "act" };

        // Sjekker om statusen som vi har fått er i acceptedStatuses
        if (!acceptedStatuses.Contains(Status))
        {
            return StatusCode(400, "Invalid value for 'Status'. Must be 'plan', 'do', 'study' or 'act'");
        }

        // Prøv skrive statusen inn i databasen
        try
        {
            await conn.QueryAsync<int>("UPDATE Forslag SET Status = @Status WHERE ForslagId = @ForslagId", new { ForslagId = ForslagId, Status = Status });
        }
        catch (Exception e)
        {
            Console.WriteLine($"databaseerror: {e.Message}");
            return StatusCode(500, "En feil har skjedd");
        }
        return Ok();
    }

    /**
     * Funksjon for omgjøre bilde til byte.
     * Vet ikke om denne fungerer helt optimalt
     */
    public static byte[] GetBilde(string filepath)
    {
        FileStream fs = new FileStream(filepath, FileMode.Open, FileAccess.Read);
        BinaryReader br = new BinaryReader(fs);

        byte[] bilde = br.ReadBytes((int)fs.Length);

        br.Close();
        fs.Close();

        return bilde;
    }


}
