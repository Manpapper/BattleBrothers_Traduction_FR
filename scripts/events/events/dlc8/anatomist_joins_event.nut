this.anatomist_joins_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_joins";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Un homme vêtu d\'une tenue grise et terne s\'approche. Au lieu d\'armes et d\'armures, il a sur lui des parchemins et des papiers, ainsi qu\'une bandoulière de fioles et de poches débordant de chair et de fourrure étranges. Il vous hèle.%SPEECH_ON%Ah, la compagnie %companyname%. J\'ai cherché des hommes ayant de telles... qualités. Vous voyez, je suis anatomiste et-%SPEECH_OFF%Vous l\'arrêtez tout de suite. Vous avez peu de temps pour les hommes qui sont obsédés par d\'étranges fascinations. Soit il veut se joindre à nous, soit il ne veut pas, et vous le lui dites laconiquement. | Vous tombez sur un homme qui est à genoux devant un chien mort. Il sonde le museau avec un long bâton et acquiesce.%SPEECH_ON%Comme vous pouvez le constater, je suis un anatomiste réputé.%SPEECH_OFF%Tournant la tête vers le haut comme une marionnette effrayante, il affirme que la compagnie %companyname% devient de plus en plus reconnue pour son travail studieux - et qu\'il souhaite la rejoindre. | Vous trouvez un manteau, un pantalon et une paire de bottes sur un rocher. A côté, il y a des bandoulières et des rames de papier avec des dessins bizarres. En regardant dehors, vous voyez un étang et un homme qui s\'y ébat. Il sursaute en vous voyant et pointe un doigt.%SPEECH_ON%Ne touchez pas à ça! Hé toi, ne touche à rien!%SPEECH_OFF%Il sort de l\'eau, ses jambes faisant maladroitement des éclaboussures à la surface. Vous apercevez que sa pilosité par endroit est plus que douteuse, l\'eau transformant son entrejambe poilu en un pagne de feutre gris. Vous dégainez votre épée et l\'homme s\'arrête.%SPEECH_ON%Retenez cet acier, voyageur. Je vois maintenant que vous avez l\'esprit curieux et moi aussi! Et, mon cher voyageur à l\'esprit d\'acier, je cherche un égal à moi-même. Que diriez-vous que je me joigne à vous?%SPEECH_OFF%Vous essayez de garder les yeux au-dessus de son cou mais le vent souffle si violemment que l\'eau entre ses jambes émets un bruit ressemblant à un chien tremblant et mouillé. Le regard vers le bas qui suit est déplorable. | Vous tombez sur un homme assis sur un rocher. En face de lui, il y a une dalle de pierre recouverte d\'animaux disséqués. Des chiots, des chatons, ce qui pourrait être une grenouille, une sorte de rongeur, et... un canard. Il saute sur ses pieds.%SPEECH_ON%Voici, voyageur, le résultat de mes études. Pourtant, il me manque encore tant de connaissances. Je peux voir que vous êtes un esprit curieux, bien que vous soyez sans doute une brute. J\'aimerais vous offrir mes services, mais je dois vous avertir que les avancées que j\'ai faites avec ces derniers sont pour moi et moi seul.%SPEECH_OFF%Il tient un bras protecteur devant les animaux disséqués, comme si vous aviez un quelconque intérêt pour eux.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Oui, nous vous emmenons.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nous n\'avons pas besoin de votre aide.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"anatomist_background"
				]);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_184.png[/img]{L\'homme s\'incline brièvement.%SPEECH_ON%Ahh, c\'est bon d\'être avec mes égaux intellectuels, même si je leur rappellerai qu\'il y en a qui sont plus égaux que d\'autres et que s\'ils souhaitent lire mes œuvres, ils peuvent en faire la demande..%SPEECH_OFF%Ouais. Bien sûr.}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Monte juste dans le wagon.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_184.png[/img]{L\'homme hoche la tête.%SPEECH_ON%C\'est normal. Je sais que lorsque j\'ai rencontré mon supérieur intellectuel, j\'ai été jaloux et j\'ai refusé toute aide de sa part. Eh bien, mon bon monsieur, puissiez-vous bien voyager et me rattraper, moi et mes découvertes!%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Ouais, va te faire foutre aussi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local numAnatomists = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				numAnatomists++;
			}
		}

		local comebackBonus = numAnatomists < 3 ? 8 : 0;
		this.m.Score = 2 + comebackBonus;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

