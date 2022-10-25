this.bad_reputation_event <- this.inherit("scripts/events/event", {
	m = {
		Superstitious = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.bad_reputation";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Quelques-uns des Oathtakers apportent un morceau de papier à votre attention. Vous y trouverez le nom de la compagnie %companyname%, un dessin plutôt amusant de vous-même qui n\'est pas du tout proportionné, et quelques descriptifs de choix de votre humble personnage. Il semble que votre réputation dans ce monde n\'est pas aussi importante et puissante que vous le pensiez.%SPEECH_ON%Nous devons rectifier cela, capitaine! Que les gens pensent aux Oathtakers de cette manière est une grande insulte pour nous, et surtout pour le Jeune Anselme!%SPEECH_OFF%Vous êtes d\'accord. | Pendant que la compagnie campe, quelques Oathtakers se plaignent de la réputation de la compagnie %companyname%.%SPEECH_ON%Le jeune Anselme ne serait pas heureux de la façon dont le monde nous voit. Nous devrions donner l\'exemple en matière de comportement!%SPEECH_OFF%Vous êtes d\'accord, bien que cela puisse prendre un certain temps pour rétablir l\'honneur des Oathtakers. | Le jeune Anselm a fondé les Oathtakers avec la conviction qu\'ils devaient être des modèles d\'honneur, de vertu et de comportement sain, des éléments que le monde avait perdus. Malheureusement, vous avez eu du mal à maintenir ces idéaux, faisant glisser la réputation de la compagnie %companyname% un peu plus bas qu\'elle ne devrait l\'être. Quelques hommes se plaignent à juste titre, et s\'ils ne se plaignent pas ouvertement, il est évident que ces fautes sapent le moral des troupes. Vous pensez qu\'il est préférable de commencer à redorer le blason de la compagnie %companyname% dès que possible, de peur que les hommes ne perdent confiance dans son objectif final.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je serai un meilleur dirigeant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(1.0, "Is upset about the company\'s evil reputation");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(0.5, "Is upset about the company\'s evil reputation");
					}

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

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Assets.getMoralReputation() >= 40.0)
		{
			return;
		}

		this.m.Score = 15;
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

