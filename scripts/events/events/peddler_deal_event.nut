this.peddler_deal_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null
	},
	function create()
	{
		this.m.ID = "event.peddler_deal";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%peddler% vient vers vous, se frottant la nuque et tirant nerveusement sur le devant de sa chemise. Il vous propose un plan dans lequel il se rend en ville avec une poignée de marchandises à colporter, comme il l\'a fait si souvent dans le passé.\n\n Le seul problème est qu\'il n\'a pas encore les marchandises - il doit les acheter à un habitant de l\'arrière-pays voisin. Tout ce dont il a besoin maintenant, c\'est d\'un peu d\'argent pour démarrer et l\'aider à acheter les marchandises. Une somme de 500 couronnes en tout et pour tout. Bien entendu, en tant que partenaire, vous recevrez une part des bénéfices une fois que tout sera terminé.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Compte sur moi !",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "C";
					}

				},
				{
					Text = "Tu es un mercenaire maintenant. Il est temps de laisser cette ancienne vie derrière vous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_04.png[/img]Vous remettez les couronnes à %peddler% et il s\'en va. Quelques heures plus tard, le colporteur arrive en courant avec un petit coffre à la main. Le sourire malicieux sur son visage est indéniable et il fait involontairement le poing pendant qu\'il glisse vers vous. Lorsqu\'il essaie de parler, il est saisi d\'un souffle. Vous lui tendez la main, lui disant de prendre son temps. S\'installant, l\'homme vous tend une lourde bourse de pièces, en précisant qu\'il s\'agit de votre part des bénéfices. Avant même que vous ne puissiez dire quoi que ce soit, l\'homme tourne sur ses talons et saute au loin, étourdi par son succès.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est un plaisir de faire affaire avec toi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				local money = this.Math.rand(100, 400);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
					}
				];
				_event.m.Peddler.getBaseProperties().Bravery += 1;
				_event.m.Peddler.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Peddler.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Détermination"
				});
				_event.m.Peddler.improveMood(2.0, "A fait du profit en colportant des marchandises");

				if (_event.m.Peddler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Peddler.getMoodState()],
						text = _event.m.Peddler.getName() + this.Const.MoodStateEvent[_event.m.Peddler.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]%peddler% s\'en va et vous vous occupez d\'autres affaires pour la journée. En sortant de votre tente quelques heures plus tard, vous apercevez au loin une forme affaissée qui se dirige vers vous. Il semble s\'agir du colporteur. Il ne porte rien d\'autre avec lui qu\'un froncement de sourcils. Alors qu\'il se rapproche, vous commencez à voir les bleus qui parsèment son corps. Il explique que, bien qu\'il ait réussi à acheter les marchandises à sa source, les habitants de la ville n\'étaient pas très chauds à l\'idée de sa tactique de vente.\n\nL\'argent investis a été perdu et %peddler% se dirige vers une tente pour soigner ses blessures.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "But...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Couronnes"
					}
				];
				_event.m.Peddler.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Peddler.getName() + " souffre de blessures légères"
				});
				_event.m.Peddler.worsenMood(2, "Son plan a failli et a perdu une grosse somme d\'argent");

				if (_event.m.Peddler.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Peddler.getMoodState()],
						text = _event.m.Peddler.getName() + this.Const.MoodStateEvent[_event.m.Peddler.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 1000)
		{
			return;
		}

		if (!this.World.State.isCampingAllowed())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 1)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Peddler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Peddler = null;
	}

});

