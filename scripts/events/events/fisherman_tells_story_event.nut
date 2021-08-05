this.fisherman_tells_story_event <- this.inherit("scripts/events/event", {
	m = {
		Fisherman = null
	},
	function create()
	{
		this.m.ID = "event.fisherman_tells_story";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]%fisherman%le vieux pêcheur, régale la compagnie avec des récits de ses jours de pêche.%SPEECH_ON%{C\'était gros comme ça. Je le jure sur ma mère ! Un poisson si gros que quand je l\'ai sorti de l\'eau, la rivière entière s\'est asséchée d\'un pied ! | L\'océan est une bête, oui, et les cieux au-dessus son maître, les vents sa chaîne, et nous les hommes les puces. | J\'étais perdu ! Un été à la dérive, le bateau entier traversé par les eaux déchainées, chaque vague a emporté un marin pour elle-même jusqu\'à ce que je sois le seul à rester, aye, aye ! C\'est la vérité ! À l\'automne, j\'ai revu la terre, et j\'étais si heureux de voir les arbres, les montagnes et les oiseaux que j\'ai fracassé mon bateau contre les rochers et embrassé le sable alors que des débris dérivaient autour de moi. Ce fut le plus beau jour de ma vie. | Je n\'ai jamais vu de grande baleine blanche, mais une verte ? Oui. Elle portait un manteau de mousse, une fourrure de terre volée. Nous l\'avons chassée avec des lances et un esprit marin. Hélas, elle s\'est rendue compte que nous étions sur elle quand %randomname% - un homme avec la meilleur précision au tir de de harpon qui ait jamais existé - l\'a frappé dans l\'évent. Je ne savais pas qu\'une baleine pouvait se retourner aussi rapidement, mais elle l\'a fait, et elle a rapidement détruit notre navire et noyé un certain nombre de marins dans son dernier acte vengeance. | Une fois, j\'ai attrapé un bar d\'environ, ouais, gros. Vous n\'y croyez pas ? D\'accord, c\'était gros comme ça. Ok, peut-être de cette taille. D\'accord, je n\'ai jamais attrapé de bar. Bien ! Je n\'ai même jamais vu de bar ! Je sais juste qu\'ils sont là ! Laissez-moi tranquille, amoureux de la terre ferme ! Je pêche en haute mer, bon sang ! Je ne connais rien de vos étangs idiots. Sauf les bars, bien sûr, je les connais.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça me semble louche.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fisherman.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "S\'est senti amusé");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.fisherman")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Fisherman = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fisherman",
			this.m.Fisherman.getName()
		]);
	}

	function onClear()
	{
		this.m.Fisherman = null;
	}

});

