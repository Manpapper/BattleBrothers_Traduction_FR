this.fell_down_well_event <- this.inherit("scripts/events/event", {
	m = {
		Strong = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.fell_down_well";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_91.png[/img]Une femme sort de la fôret en sautant à côté du chemin.%SPEECH_ON%Oh, grâce aux dieux, mes prières ont été entendues ! S\'il vous plaît, venez vite ! Mon grand-père est tombé dans le puits !%SPEECH_OFF%Elle se retourne et s\'éloigne comme si vous aviez déjà accepté de l\'aider. %otherbrother% vous regarde et hausse les épaules.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je suppose que nous pouvons l\'aider.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Strong != null)
				{
					this.Options.push({
						Text = "%strongbrother%, tu es fort. Donne-lui un coup de main.",
						function getResult( _event )
						{
							return "Strong";
						}

					});
				}

				this.Options.push({
					Text = "Nous n\'avons pas le temps pour ça.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_91.png[/img]Vous décidez que cela vaut la peine d\'essayer et vous allez jeter un coup d\'oeil. Le vieil homme effectuait des réparations sur le haut du puits, une structure en bois destinée à couvrir l\'ouverture du puit, lorsqu\'elle s\'est brisée il est tombé. En regardant dans le puits, vous voyez l\'homme qui regarde vers le haut. Il fait un signe de la main.%SPEECH_ON%Bonjour, les gars. Je suis un peu dans le pétrin. Je suis en fait en train de me faire mariner, maintenant que j\'y pense...%SPEECH_OFF%Eh, d\'accord. %otherbrother% jette une corde et le vieil homme l\'attache autour de lui. Le mercenaire et vous tirez le grand-père de la femme et le ramenez sur la terre ferme. Il vous serre la main et vous remercie cordialement.%SPEECH_ON%Putain de merde, content que vous soyez venu, j\'étais sur le point de chier et de pisser comme personne. Laissez-moi vous dire que ce n\'était pas la première fois que je descendais dans un puits. Il y a cinq ans, je l\'avais fait en réparant la tête de puits, parce que la tête de puits se casse souvent, vous voyez. Et ce n\'est pas vraiment une tête de puits, on l\'appelle comme ça parce qu\'on est paresseux. De mon temps, on appelait ça une... enfin, heh bien, j\'ai oublié en fait. Je suppose qu\'une \"tête de puits\" a du sens maintenant, puisque je ne suis pas bien dans ma tête ! Ho ! Je l\'ai toujours. J\'étais un charmeur dans le temps, vous voyez, et ce n\'est pas souvent que j\'ai l\'occasion de m\'entraîner. Ma femme est morte il y a dix ans, et celle qui l\'a précédée m\'a quitté il y a vingt hivers ! Je dis hivers, parce que c\'est là qu\'elle m\'a quitté, en hiver. C\'était un hiver brutal et je lui avais demandé d\'aider à couper le bois de peur que nous ne soyons tous gelés. Elle a dit qu\'elle ne pouvait pas faire cette merde et s\'occuper des enfants en même temps. J\'ai eu des enfants avec elle ainsi qu\'avec la seconde femme. Cinq au total. Un est mort. La rougeole. Un autre a disparu, donc il est probablement mort. J\'essaie d\'être honnête avec moi-même à ce sujet, mais vous savez, il y a de l\'espoir. Si un étranger peut être trouvé dans la forêt pour me sauver à temps, alors peut-être que mon fils a survécu à cette bataille avec les peaux vertes. Je n\'ai jamais entendu parler de lui, cependant. Je prie les anciens dieux et même ce Davkul de temps en temps. Connaissez-vous Davkul ? Je ne sais pas trop quoi en penser. Un jour, un homme est venu avec une cicatrice sur le front, il a dit qu\'il me montrerait le chemin des ténèbres. J\'ai dit que je voyais les ténèbres à chaque fois que je faisais une sieste. Ce type à la cicatrice a dit qu\'un jour je ne me réveillerais pas et j\'ai dit que c\'était bien ! Ha ! Alors ce bâtard balafré commence à s\'énerver contre moi...%SPEECH_OFF%Tandis qu\'il continue, vous regardez autour de vous à la recherche de %otherbrother%, mais vous le trouvez en train de sortir de la maison de la femme, la dame elle-même ayant... une chaleur évidente sur son visage. Vous récupérez votre mercenaire et partez avant que le vieil homme ne vous coupe la tête avec la conversation la plus longue et unilatérale qui soit.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Personne n\'est jamais là pour me sauver.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.improveMood(2.0, "A reçu un peu d\'amour");

				if (_event.m.Other.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_91.png[/img]Le vieil homme faisait des réparations au sommet du puits en bois quand il s\'est brisé. Malheureusement, si vous vous tenez au sommet du puits quand ils\'effondre, il n\'y a qu\'un seul endroit où aller : en bas. Très, très bas. En regardant par-dessus le bord du puits, vous pouvez voir le vieil homme flotter dans d\'une matière peu vivante. %otherbrother% s\'approche de vous et chuchote, utilisant une main pour ne pas être entendu.%SPEECH_ON%Euh, il ne bouge pas.%SPEECH_OFF%Une observation experte, vraiment. Vous informez la dame du décès de l\'homme. Elle pince les lèvres et demande que vous enleviez quand même le corps, expliquant son raisonnement plutôt succinctement.%SPEECH_ON%On ne peut pas boire sa saleté après tout.%SPEECH_OFF%C\'est juste. %otherbrother% réussit à accrocher une corde autour du cadavre et à le remonter, ses membres pendent comme du linge. Il demande si elle a besoin de vous pour l\'enterrer aussi. La femme essuie une larme et secoue la tête.%SPEECH_ON%Non. J\'enterrerai ce vieux crouton moi-même, je pleurerai sur sa tombe demain, et je continuerai à vivre.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon, d\'accord.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Strong",
			Text = "[img]gfx/ui/events/event_91.png[/img]Vous décidez que cela vaut la peine d\'essayer et vous allez jeter un coup d\'oeil. Le haut du puits, une structure en bois destinée à couvrir son ouverture, s\'est brisée. Apparemment, le vieil homme effectuait des réparations à son sommet lorsque cela s\'est produit et il a plongé dans le puits. Il lève les yeux vers vous.%SPEECH_ON%Bonjour, les gars. Je suis un peu dans le pétrin. Je suis en fait en train de me faire mariner maintenant que j\'y pense...%SPEECH_OFF%Eh, c\'est vrai. %strongbrother% jette une corde. Le vieil homme l\'attache autour de lui. Vous et le mercenaire tirez le grand-père de la femme et le ramenez sur la terre ferme. Il vous serre la main et vous remercie cordialement.%SPEECH_ON%Putain, je suis content que vous soyez venu, j\'étais sur le point de chier et de pisser comme personne d\'autre.%SPEECH_OFF%Vous parlez avec le vieil homme pendant un certain temps, apprenant beaucoup de choses sur lui. Un peu plus tard, vous réalisez que %strongbrother% n\'est pas dans les parages. Au moment où vous pensez commencer à le chercher, il sort de la maison de la femme. Elle s\'accroche à ses muscles et se montre plutôt tactile.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il y aura bientôt des gars forts dans cette région, sans aucun doute...",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Strong.getImagePath());
				_event.m.Strong.improveMood(2.0, "A reçu un peu d\'amour");

				if (_event.m.Strong.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Strong.getMoodState()],
						text = _event.m.Strong.getName() + this.Const.MoodStateEvent[_event.m.Strong.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_strong = [];
		local candidates_other = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getSkills().hasSkill("trait.strong"))
			{
				candidates_strong.push(b);
			}
			else
			{
				candidates_other.push(b);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_strong.len() != 0)
		{
			this.m.Strong = candidates_strong[this.Math.rand(0, candidates_strong.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
		_vars.push([
			"strongbrother",
			this.m.Strong != null ? this.m.Strong.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Strong = null;
	}

});

