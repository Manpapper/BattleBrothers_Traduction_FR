this.disowned_noble_reminisces_event <- this.inherit("scripts/events/event", {
	m = {
		Disowned = null
	},
	function create()
	{
		this.m.ID = "event.disowned_noble_reminisces";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]Vous trouvez %disowned% assis tout seul à l\'extérieur du camp. Alors que les huées et les acclamations des hommes autour du feu de camp crépitent derrière vous, vous vous approchez de l\'homme et lui demandez pourquoi il boude. Il hausse les épaules.%SPEECH_ON%Je ne boude pas, monsieur, je réfléchis. Bien que je suppose que l\'on pourrait facilement confondre l\'un avec l\'autre.%SPEECH_OFF%En ricanant, il vous offre un peu de sa boisson, que vous prenez. En vous installant à côté de lui, vous lui demandez à quoi il pense. Le noble désavoué hausse à nouveau les épaules.%SPEECH_ON%Ahh, rien vraiment. Je pense juste à la maison. J\'en suis très loin maintenant, et les derniers souvenirs que j\'en ai ne sont pas vraiment les meilleurs, pourtant je me surprends à souhaiter y être de temps en temps. J\'ai le mal du pays pour un lieu qui me considère comme une sorte de maladie noble, allez savoir.%SPEECH_OFF%Vous lui rendez son verre car il en a probablement plus besoin que vous. Pendant que vous êtes encore lucide, vous essayez de dire ce que vous pensez...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au diable l\'ancienne maison, tu es avec nous maintenant.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "C\'est normal de penser à la maison de temps en temps.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				_event.m.Disowned.getFlags().set("disowned_noble_reminisces", true);
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]Vous parlez.%SPEECH_ON%L\'endroit d\'où vous venez est une maison, pas un foyer. Tu as envie d\'un autre endroit, d\'une autre époque, alors que tu es ici maintenant. %companyname% s\'occupe de toi, et toi de lui, et ce n\'est qu\'ensemble que nous persévérerons.%SPEECH_OFF%L\'homme regarde fixement son verre pendant un moment. Il glousse, boit une gorgée et essuie la mousse.%SPEECH_ON%Oui, je suppose que c\'est une façon de voir les choses. Merci, capitaine.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "N\'importe quand.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				local resolve = this.Math.rand(1, 3);
				_event.m.Disowned.getBaseProperties().Bravery += resolve;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Disowned.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] de Détermination"
				});
				_event.m.Disowned.improveMood(1.0, "A eu une bonne discussion avec vous");

				if (_event.m.Disowned.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Disowned.getMoodState()],
						text = _event.m.Disowned.getName() + this.Const.MoodStateEvent[_event.m.Disowned.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_26.png[/img]Vous tapez sur l\'épaule de l\'homme et parlez.%SPEECH_ON%Hé, penser au passé est bon pour l\'âme, même si c\'est à travers un fourré de merde, de cruauté et de mal, c\'est tout ce qui fait qu\'un homme reste éveillé la nuit. Mais ce n\'est bon que pendant un temps. Tu regardes le passé, tu le regardes, et puis tu passes à autre chose. Il faut être sûr de ne visiter que le passé, pas de s\'y attarder. Tout le monde ici a un passé, %disowned%, et à cet égard, tu ne seras jamais seul.%SPEECH_OFF%Le noble désavoué fixe le sol pendant un moment. Il commence lentement à hocher la tête.%SPEECH_ON%Oui, oui, c\'est vrai. Je suppose qu\'une partie de moi s\'inquiétait du fait que je voulais vraiment retourner là-bas. Je l\'imaginais avec l\'âtre allumé, la fumée sortant de la cheminée, la douce lumière des bougies derrière les fenêtres, et ma famille qui m\'attendait. J\'ignorais la porte verrouillée, les chiens de garde accroupis à l\'extérieur, et ceux que j\'aime qui me disent de ne jamais revenir de peur que je ne finisse dans une boîte enterrée loin sous terre. Je ne pensais pas à mon passé autant que j\'en rêvais, et je pense que vous m\'avez aidé à le réaliser, capitaine. Merci. Je sais qu\'un jour, je n\'aurai plus à rêver de %companyname%, mais à m\'en souvenir clairement et tendrement.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La compagnie apprécie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				local resolve = this.Math.rand(1, 3);
				_event.m.Disowned.getBaseProperties().Bravery += resolve;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Disowned.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] de Détermination"
				});
				_event.m.Disowned.improveMood(1.0, "A eu une bonne discussion avec vous");

				if (_event.m.Disowned.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Disowned.getMoodState()],
						text = _event.m.Disowned.getName() + this.Const.MoodStateEvent[_event.m.Disowned.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 5 && bro.getBackground().getID() == "background.disowned_noble" && !bro.getFlags().get("disowned_noble_reminisces"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Disowned = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"disowned",
			this.m.Disowned.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Disowned = null;
	}

});

