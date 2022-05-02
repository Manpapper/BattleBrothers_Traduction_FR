this.schrat_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.schrat_exposition";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Vous rencontrez un jeune voyageur sur la route. Son chapeau de paille est à l\'envers, comme s\'il voulait qu\'il attrape la pluie. Il a un bâton de marche dont le bout est taillé en boule pour parcourir les chemins boueux. Lorsque vous vous approchez, il se redresse et pose ses mains sur le haut du bâton.%SPEECH_ON%Oh, vous êtes des mercenaires ? J\'éviterais les forêts si j\'étais vous. On dit que les arbres errent dans ces régions maintenant. Ils ne sont pas menaçants, pas plus qu\'un ours miteux quand il vous dévore les couilles pour vous être approché trop près. C\'est une question de nature, la protection de territoire vous savez ?%SPEECH_OFF%Euh, bien sûr. | Un homme est trouvé au bord de la route en train de lire quelques livres. Il lève les yeux et tourne l\'une des pages pour que vous puissiez la voir, affichant le dessin d\'un arbre avec de longues branches étendues jusqu\'au sol. Le tronc est éclairé par des yeux.%SPEECH_ON%On les appelle des schtrats. Des arbres qui griffent et tuent tout ce qui s\'approche, mais je ne pense pas que ce soit tout à fait exact. Je ne pense pas que ce soit des animaux, je pense que ce sont des monstres calculateurs et intelligents avec une attitude vengeresse en cas d\'intrusion. Alors, ne les dérangez pas, compris ? Restez en dehors des forêts.%SPEECH_OFF%N\'étant pas d\'humeur à parler inutilement des arbres, vous lui souhaitez bonne chance dans ses études et passez rapidement à autre chose. | Une femme âgée portant un panier croise le chemin de votre compagnie. Elle fait un geste vers la marchandise, un tas de bois de chauffage coupé.%SPEECH_ON%Si vous voulez du bois, mieux vaut rester loin de là où je l\'ai eu.%SPEECH_OFF%Vous demandez ce qu\'elle veut dire. Elle fait un sourire malicieux.%SPEECH_ON%Un schrat dans la forêt m\'a regardé faire et m\'a donné la permission de me réchauffer avec cette allumette. Il n\'a pas donné la permission à mon oncle. Il a déchiré mon oncle en deux et a pendu sa chair. Peut-être une valeur ornementale, vous savez ?%SPEECH_OFF%Er, of course.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un ennemi tel que celui-ci ne doit pas être pris à la légère.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type == this.Const.World.TerrainType.Desert || currentTile.Type == this.Const.World.TerrainType.Oasis || currentTile.TacticalType == this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

