this.ancient_statue_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.ancient_statue";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_116.png[/img]{Un homme couvert d\'or est assis sur un trône de pierre avec une posture si majestueuse qu\'il semble que même lui, aussi inanimé qu\'il soit, devrait gouverner le pays. Et peut-être que le monde s\'en porterait mieux, cette entité muette à la présence si impressionnante ferait un meilleur dirigeant que le lot de putois que vous rencontrez constamment. La statue repose sur un énorme disque fait de pierres carrées en spirale. S\'il s\'agissait de cercueils, il faudrait deux briques pour stocker l\'ensemble de la compagnie %companyname%. %randombrother% incline son casque vers le haut.%SPEECH_ON%Si ce n\'est pas la plus grosse chose que j\'ai jamais vue, je ne sais pas ce que c\'est.%SPEECH_OFF%%randombrother2% sourit et tend la main vers l\'entrejambe du mercenaire.%SPEECH_ON%Je croyais que les femmes disaient que ce petit ver était la plus grosse chose qu\'on ait jamais vue !%SPEECH_OFF%Alors que la compagnie rit, vous vous avancez et levez les yeux. Vous n\'êtes pas du genre à vous agenouiller, mais vous en ressentez le besoin ici. La statue domine son environnement avec une certaine autorité, ses mains sont tendues sur les côtés, l\'une sur une épée plantée dans le sol, l\'autre en supination comme pour peser la justice elle-même. Vous faites un signe de tête à l\'éclat doré présent devant vous. Le fait qu\'il n\'y ait pas une seule trace du passage d\'un quelconque voleur ici, suggère que cette statue a encore une certaine emprise éthérée sur le monde. Mais cela n\'a pas de sens. N\'importe quel homme intelligent se contenterait d\'une partie des tibias de la statue. Quelques mercenaires demandent s\'ils peuvent mettre un coup de couteau pour collecter un peu d\'or pour eux-mêmes.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il n\'y a pas de mal à cela.",
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
			Text = "[img]gfx/ui/events/event_116.png[/img]{La statue est si énorme qu\'elle a peut-être effrayé les petits vauriens par simple superstition. Vous n\'avez aucune raison de laisser passer une telle découverte, un tas d\'or presque infini façonné en quelque chose de \"joli\". Au diable l\'histoire et l\'art. Vous dites aux hommes de la prendre. Ils s\'attellent à la tâche avec les outils disponibles, mais à la seconde où %randombrother% touche la statue, il s\'effondre et s\'affale contre elle. Un autre mercenaire va l\'aider, effleure l\'énorme orteil de la statue et s\'effondre sur le mercenaire. Au moment où la compagnie commence à paniquer, les deux mercenaires se relèvent d\'un bond et se mettent à hurler à propos de visions extraordinaires, de visions au-delà de ce monde, de visions du futur lui-même!\n\n Revigorés, les membres de la compagnie se précipitent volontiers sur la statue, se cognant à ses orteils géants et tombant à la renverse comme des mimes découvrant inopinément un mur bien réel. C\'est la chose la plus ridicule que vous ayez jamais vue, mais chaque homme se remet sur pied en racontant des histoires fantastiques. Vous haussez les épaules et vous vous approchez vous-même de la statue, vous tenant devant le gros orteil avec son gros ongle. Les hommes vous poussent à avancer. En soupirant, vous tendez la main et touchez l\'ongle de l\'orteil. Rien. Il ne se passe rien. Vous mettez le poing dans l\'espace entre l\'ongle et la chair dorée. Vous mettez furieusement les deux mains sur l\'orteil comme s\'il vous devait de l\'argent. Rien. Bon. On dirait que vous avez des richesses à récolter. Vous dégainez votre épée...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il est temps de récolter de l\'or.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_116.png[/img]{Vous balancez l\'épée, mais à la seconde où l\'acier touche l\'or, un éclair lumineux vous envahit comme si vous aviez frappé le soleil lui-même et fait couler le sang. L\'épée continue dans l\'obscurité comme une étoile dans le ciel nocturne, elle découpe la réalité et fait apparaitre un monde parallèle, comme si vous aviez vu l\'envers du décors d\'un tour de magie, révélant une pièce avec des piliers et de beaux rideaux de soie, l\'épée continue jusqu\'à ce qu\'elle heurte le manche d\'une lance. Vous baissez les yeux pour voir un homme avec une armure dorée et des yeux rouges qui tient sa garde en grimaçant. Il se lance dans votre direction et vous fait tomber, puis il prend sa lance, l\'a fait tournoyer et vous porte un coup. Vous arrivez esquiver l\'attaque en mettant sur le côté, vous vous relevez en un éclair puis saisissez la lance sous votre aisselle pour vous rapprocher du tueur, le poignardant sous son pauldron, enfonçant l\'épée dans le coeur. Les yeux rouges de l\'homme se transforment en un blanc pur, il devient mou et glisse directement sur l\'acier.\n\n Alors qu\'il s\'effondre sur le sol, vous regardez rapidement autour de vous. Contre le mur du fond se dresse un énorme lit avec des coins marbrés, chaque marbre ayant la forme d\'une femme ou d\'un homme, chacun d\'eux étant présenté de manière soumise à ce qu\'on dirait un soleil levant. Il y a un vieil homme dans un lit qui vous observe. Barbu. Des yeux sombres, usés par le temps. Une familiarité dans son regard. Il sourit, mais son sourire s\'efface rapidement. Il crie, mais vous ne comprenez pas les mots. Une ombre se glisse dans la pièce, vous vous retournez pour apercevoir un grand chevalier, les yeux remplis de flammes, il attaque avec un couteau à deux mains.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Parer!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_116.png[/img]{Vous reculez et faites pivoter votre épée en croix, vous vous accroupissez pour vous préparer à l\'impact. Le couteau de l\'assassin se heurte à votre épée , le monde parallèle se disloque, toujours figé dans une parade, vous pouvez sentir la délivrance du temps et de l\'espace voler à tes côtés, des quantités impies de souffrance, de cris, de vie et de mort, et au loin un point lumineux qui s\'approche rapidement jusqu\'à ce que vous revenez dans votre corps et que votre épée frappe la statue si fort qu\'elle s\'envole dans les airs jusqu\'à ce qu\'elle se plante dans le sol. Les hommes se regardent les uns les autres. Vous allez chercher ton épée.%SPEECH_ON%Je pense que vous l\'avez cassé, monsieur.%SPEECH_OFF%Dit %randombrother% en se frottant le petit doigt de pied. Vous lui dites, ainsi qu\'au reste des hommes, de faire leurs bagages, il est temps de quitter cet endroit. En regardant la statue, vous constatez qu\'elle n\'est plus que de bronze rouillé. Vous pensez demander à l\'un des mercenaires si elle était en or auparavant, mais vous connaissez déjà la réponse à cette question. Au lieu de cela, vous fixez la tête de la statue. Le visage. Un visage très familier.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ne nous attardons pas sur ce point.",
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
					bro.improveMood(1.5, "Impressed by a magnificent statue of old");

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

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

