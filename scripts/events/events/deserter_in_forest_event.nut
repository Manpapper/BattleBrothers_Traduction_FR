this.deserter_in_forest_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.deserter_in_forest";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Alors que vous traversez la forêt, des oiseaux se dispersent soudainement dans le ciel, faisant trembler les arbres et les branches dans l\'urgence effrayante de leur départ. Peu de temps après, un homme traverse un buisson à toute vitesse, ressemblant plus à un flash qu\'à de la chair et du sang. Il vous montre, un golem de terre, et vous supplie de le cacher.%SPEECH_ON%Écoutez, je vais être parfaitement honnête. Je suis un déserteur. C\'est comme ça. Je n\'avais pas, je veux dire, d\'accord, je n\'ai pas vraiment de défense. Mais écoutez, qu\'est-ce que vous êtes ? Des mercenaires ? Super ! Cachez-moi et je me battrai pour vous jusqu\'à la fin des temps !%SPEECH_OFF%Au milieu de son discours de supplication, vous entendez des chiens aboyer au loin. L\'homme se réfugie instinctivement dans un buisson, se couvrant rapidement de terre. Il hoche la tête comme pour dire que vous êtes déjà parvenu à un accord.\n\nDes chasseurs de primes traversent la ligne d\'arbres, leurs chiens reniflant déjà les environs. Leur lieutenant regarde autour de lui.%SPEECH_ON%N\'essaie même pas de me tromper, mercenaire. Je sais que ce déserteur est passé par ici. Deux cents couronnes pour sa tête. Où est-il ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il est juste là, prenez-le.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Qui ? Quoi ? Où ?",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous crachez et secouez la tête.%SPEECH_ON%Je n\'ai pas la moindre idée de ce dont vous parlez, chasseur de primes.%SPEECH_OFF%Le lieutenant vous regarde, vous fixant avec la sagesse d\'un vieil homme.%SPEECH_ON%D\'accord, mercenaire. Ainsi soit-il. Je sais que tu mens, mais je ne peux pas y faire grand-chose.%SPEECH_OFF%Le chasseur de primes émet un sifflement aigu et ordonne à ses hommes d\'avancer. Les chiens aboient brièvement dans le buisson où s\'était caché le déserteur. En riant, le lieutenant vous souhaite, sur un ton moqueur, le meilleur.\n\n Avec les chasseurs partis, le déserteur sort de sa cachette.%SPEECH_ON%Merci, mercenaire. Je te dois la vie ! Tu ne le regretteras jamais !%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'espère ne pas le regretter. Bienvenue dans la compagnie.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Continue à courir. Nous n\'avons pas de place pour un déserteur.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"deserter_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Vous avez trouvé %name% le déserteur poursuivi dans la forêt. Bien que des chasseurs de primes soient à ses trousses, vous avez choisi de le défendre et pour cela, il vous a prêté serment.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_25.png[/img]Vous faites un signe de tête vers l\'endroit où se cache le déserteur. Il a dû garder un œil méfiant sur vous car il saute immédiatement du trou et s\'enfuit. Les chiens l\'écrasent facilement, s\'accrochant à lui avec une férocité canine et le traîne alors qu\'il hurle en étant au sol. Avant que vous ne puissiez ne serait-ce que rire, le chasseur de primes dépose un sac de couronnes dans votre main.%SPEECH_ON%C\'est la moitié de ma part, mais sans votre présence ici, je ne suis pas sûr que nous aurions attrapé ce bâtard rusé.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je fais juste ma part.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(200);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]200[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.deserter")
					{
						bro.worsenMood(0.5, "Vous avez livré un déserteur aux chasseurs de primes.");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		this.m.Score = 10;
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

